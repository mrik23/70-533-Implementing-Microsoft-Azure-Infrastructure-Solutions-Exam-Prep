#Azure PowerShell v2
#Check documentation https://docs.microsoft.com/en-us/powershell/azure/active-directory/install-adv2?view=azureadps-2.0

Import-Module AzureRM
$credential = Get-Credential
Login-AzureRmAccount -Credential $credential

#Get all cmdlets related to Azure Compute
#Get-Command * -Module AzureRM.Compute

#Set variables
$location = "eastus" #Find the choice of location with 'Get-AzureRmLocation | select location'
$rgName = "myResourceGroup" + (Get-Random -Maximum 99).ToString()
$subnetName = "mySubnet"  + (Get-Random -Maximum 99).ToString()
$subnetAddress = "10.0.1.0/24"
$vnetName = "myVNET" + (Get-Random -Maximum 99).ToString()
$vnetAddress = "10.0.0.0/16"
$nsgName = "myNetworkSecurityGroup"  + (Get-Random -Maximum 99).ToString()
$vmName = "myVM" + (Get-Random -Maximum 999).ToString()
$dataDiskName = $vmName.ToLower() + "_datadisk01-" + (Get-Random -Maximum 99999).ToString()
$availabilitySetName = "myAS" + (Get-Random -Maximum 99).ToString()
$nicName = $vmName.ToLower() + "_nic01"
$vmSize = "Standard_A1" #Find VM size options with 'Get-AzureRmVMSize -location $location'
$imagePublisher = "MicrosoftWindowsServer" #Find with 'Get-AzureRmVMImagePublisher -Location $location'
$imageOffer = "WindowsServer" #Find with 'Get-AzureRmVMImageOffer -Location $location -PublisherName $imagePublisher'
$vmImageSkus = "2012-R2-Datacenter" #FInd with 'Get-AzureRmVMImageSku -Location $location -PublisherName $imagePublisher -Offer $imageOffer'

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
        -Name "mypublicdns$(Get-Random)" -AllocationMethod Static -IdleTimeoutInMinutes 4

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
$dataDiskConfig = New-AzureRmDiskConfig -AccountType "StandardLRS" -Location $resourceGroup.Location -CreateOption Empty `
                -DiskSizeGB 32

$dataDisk = New-AzureRmDisk -DiskName $dataDiskName -Disk $dataDiskConfig -ResourceGroupName $resourceGroup.ResourceGroupName

# Create a virtual machine configuration
$vmConfig = New-AzureRmVMConfig -VMName $vmName -VMSize $vmSize -AvailabilitySetId $availabilitySet.Id | `
    Set-AzureRmVMOperatingSystem -Windows -ComputerName $vmName -Credential $cred | `
    Set-AzureRmVMSourceImage -PublisherName $imagePublisher -Offer $imageOffer `
    -Skus $vmImageSkus -Version latest | Add-AzureRmVMNetworkInterface -Id $nic.Id | `
    Add-AzureRmVMDataDisk -Name $dataDiskName -Lun 1 -CreateOption Attach -ManagedDiskId $dataDisk.Id

New-AzureRmVM -ResourceGroupName $resourceGroup.ResourceGroupName -Location $resourceGroup.Location -VM $vmConfig

#Get the virtual machine created
$vm = Get-AzureRmVM -ResourceGroupName $resourceGroup.ResourceGroupName -Name $vmName

<#
    The resource group can be deleted to remove all resources deployed when done.
#>
#Remove-AzureRmResourceGroup -Name $resourceGroup.ResourceGroupName -Force
