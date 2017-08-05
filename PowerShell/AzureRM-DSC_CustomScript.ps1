#Azure PowerShell v2
#Check documentation https://docs.microsoft.com/en-us/powershell/azure/active-directory/install-adv2?view=azureadps-2.0

Import-Module AzureRM
$credential = Get-Credential
Login-AzureRmAccount -Credential $credential

#Set variables
$location = "eastus" #Find the choice of location with 'Get-AzureRmLocation | select location'
$rgName = "myResourceGroup" + (Get-Random -Maximum 99).ToString()
$subnetName = "mySubnet"  + (Get-Random -Maximum 99).ToString()
$subnetAddress = "10.0.1.0/24"
$vnetName = "myVNET" + (Get-Random -Maximum 99).ToString()
$vnetAddress = "10.0.0.0/16"
$nsgName = "myNetworkSecurityGroup"  + (Get-Random -Maximum 99).ToString()
$vmName = "myVM" + (Get-Random -Maximum 999).ToString()
$dataDiskName = $vmName.ToLower() + "_datadisk01"
$availabilitySetName = "myAS" + (Get-Random -Maximum 99).ToString()
$nicName = $vmName.ToLower() + "_nic01"
$vmSize = "Standard_A1" #Find VM size options with 'Get-AzureRmVMSize -location $location'
$imagePublisher = "MicrosoftWindowsServer" #Find with 'Get-AzureRmVMImagePublisher -Location $location'
$imageOffer = "WindowsServer" #Find with 'Get-AzureRmVMImageOffer -Location $location -PublisherName $imagePublisher'
$vmImageSkus = "2012-R2-Datacenter" #FInd with 'Get-AzureRmVMImageSku -Location $location -PublisherName $imagePublisher -Offer $imageOffer'
$storageAccountName = ("myStorageAccount" + (Get-Random -Maximum 999).ToString()).ToLower()
$storageSku = "Standard_LRS" #Choice between Standard_LRS, Standard_ZRS, Standard_GRS, Standard_RAGRS and Premium_LRS
$storageKind = "Storage" #Choice between BlobStorage and Storage

#Create VM credential
$securePassword = ConvertTo-SecureString 'myPasswordIsS3cure' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ("myAdminUser", $securePassword)

#Create the resouce group
$resourceGroup = New-AzureRmResourceGroup -Name $rgName -Location $location

#Create the avaibility set for the VM
$availabilitySet = New-AzureRmAvailabilitySet -Name $availabilitySetName -ResourceGroupName $resourceGroup.ResourceGroupName -Location $resourceGroup.Location -Sku "Aligned" -PlatformFaultDomainCount 2 -PlatformUpdateDomainCount 5

#Create a subnet and virtual network
$subnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix $subnetAddress
$vnet = New-AzureRmVirtualNetwork -ResourceGroupName $resourceGroup.ResourceGroupName -Location $resourceGroup.Location `
        -Name $vnetName -AddressPrefix $vnetAddress -Subnet $subnetConfig

#Create a public IP address
$pip = New-AzureRmPublicIpAddress -ResourceGroupName $resourceGroup.ResourceGroupName -Location $resourceGroup.Location `
        -Name ($vmName + "_pip") -AllocationMethod Static -IdleTimeoutInMinutes 4

# Create an inbound network security group rule for port 3389
$nsgRuleRDP = New-AzureRmNetworkSecurityRuleConfig -Name AllowRDP  -Protocol Tcp `
  -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * `
  -DestinationPortRange 3389 -Access Allow

# Create a network security group
$nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $resourceGroup.ResourceGroupName -Location $resourceGroup.Location `
        -Name $nsgName -SecurityRules $nsgRuleRDP

# Create a virtual network card and associate with public IP address and NSG
$nic = New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $resourceGroup.ResourceGroupName -Location $resourceGroup.Location `
        -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id

#Create a data disk for the VM
$dataDiskConfig = New-AzureRmDiskConfig -AccountType "StandardLRS" -Location $resourceGroup.Location -CreateOption Empty -DiskSizeGB 32
$dataDisk = New-AzureRmDisk -DiskName $dataDiskName -Disk $dataDiskConfig -ResourceGroupName $resourceGroup.ResourceGroupName

# Create a virtual machine configuration
$vmConfig = New-AzureRmVMConfig -VMName $vmName -VMSize $vmSize -AvailabilitySetId $availabilitySet.Id | `
    Set-AzureRmVMOperatingSystem -Windows -ComputerName $vmName -Credential $cred | `
    Set-AzureRmVMSourceImage -PublisherName $imagePublisher -Offer $imageOffer `
    -Skus $vmImageSkus -Version latest | Add-AzureRmVMNetworkInterface -Id $nic.Id | `
    Add-AzureRmVMDataDisk -Name $dataDiskName -Lun 1 -CreateOption Attach -ManagedDiskId $dataDisk.Id

New-AzureRmVM -ResourceGroupName $resourceGroup.ResourceGroupName -Location $resourceGroup.Location -VM $vmConfig

$vm = Get-AzureRmVM -ResourceGroupName $resourceGroup.ResourceGroupName -Name $vmName

#Create the storage account
$storageAccount = New-AzureRmStorageAccount -ResourceGroupName $resourceGroup.ResourceGroupName -Name $storageAccountName `
                -SkuName $storageSku -Location $resourceGroup.Location -Kind $storageKind

#Publish the configuration script into user storage
Publish-AzureRmVMDscConfiguration -ConfigurationPath .\PowerShell\iisInstall.ps1 -ResourceGroupName $resourceGroup.ResourceGroupName `
                                    -StorageAccountName $storageAccount.StorageAccountName -force
#Set the VM to run the DSC configuration
Set-AzureRmVmDscExtension -Version 2.21 -ResourceGroupName $resourceGroup.ResourceGroupName `
                        -VMName $vm.Name -ArchiveStorageAccountName $storageAccount.StorageAccountName `
                        -ArchiveBlobName iisInstall.ps1.zip -AutoUpdate:$true -ConfigurationName "IISInstall"

#Add inbound rule for port 80 in network security group
$nsg = Get-AzureRmNetworkSecurityGroup -Name $nsg.Name -ResourceGroupName $resourceGroup.ResourceGroupName `
        | Add-AzureRmNetworkSecurityRuleConfig -Name "AllowHTTP" -Description "Allow HTTP" `
        -Access "Allow" -Protocol "Tcp" -Direction "Inbound" -Priority 100 -SourceAddressPrefix "*" `
        -SourcePortRange "*" -DestinationAddressPrefix "*" -DestinationPortRange "80" `
        | Set-AzureRmNetworkSecurityGroup

#Get the storage account keys
$storageAccountKey = Get-AzureRmStorageAccountKey -ResourceGroupName $resourceGroup.ResourceGroupName `
                    -Name $storageAccount.StorageAccountName

#Set the storage account context
$storageContext = New-AzureStorageContext -StorageAccountName $storageAccount.StorageAccountName `
                -StorageAccountKey ($storageAccountKey | Where-Object -Property "KeyName" -Like "key1").Value

#Create a container in the blob storage account
$container = New-AzureStorageContainer -Name "customscript" -Permission "Blob" -Context $storageContext

#Upload file to blob storage container
$scriptBlob = Set-AzureStorageBlobContent -Container $container.Name -File ".\PowerShell\myScript.ps1" `
                -Blob "myScript.ps1" -Context $storageContext -Force

#Add index.html to wwwroot with custom script
Set-AzureRmVMCustomScriptExtension -ResourceGroupName $resourceGroup.ResourceGroupName `
    -VMName $vm.Name -Location $resourceGroup.Location `
    -FileUri $scriptBlob.ICloudBlob.StorageUri.PrimaryUri.AbsoluteUri `
    -Run 'myScript.ps1' -Name myScriptExtension
