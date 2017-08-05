#Azure PowerShell v2
#Check documentation https://docs.microsoft.com/en-us/powershell/azure/active-directory/install-adv2?view=azureadps-2.0

Import-Module AzureRM
$credential = Get-Credential
Login-AzureRmAccount -Credential $credential

#Set variables
$location = "eastus" #Find the choice of location with 'Get-AzureRmLocation | select location'
$rgName = "myResourceGroup" + (Get-Random -Maximum 99).ToString()
$availabilitySetName = "myAS" + (Get-Random -Maximum 99).ToString()
$vnetName = "myVNET" + (Get-Random -Maximum 99).ToString()
$vnetAddress = "10.0.0.0/16"
$subnetName = "mySubnet"  + (Get-Random -Maximum 99).ToString()
$subnetAddress = "10.0.1.0/24"
$privateIP1 = "10.0.1.10"
$privateIP2 = "10.0.1.20"
$dnsNameLB = ("myLoadBalancer" + (Get-Random -Maximum 9999).ToString()).ToLower()
$loadBalancerName = "myLoadBalancer"
$nsgName = "myNetworkSecurityGroup" + (Get-Random -Maximum 99).ToString()
$vmName1 = "myVM" + (Get-Random -Maximum 9999).ToString()
$vmName2 = "myVM" + (Get-Random -Maximum 9999).ToString()
$nicName1 = $vmName1.ToLower() + "_nic01"
$nicName2 = $vmName2.ToLower() + "_nic01"
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

#Create the avaibility set for the VMs
$availabilitySet = New-AzureRmAvailabilitySet -Name $availabilitySetName -ResourceGroupName $resourceGroup.ResourceGroupName -Location $resourceGroup.Location -Sku "Aligned" -PlatformFaultDomainCount 2 -PlatformUpdateDomainCount 5

#Create a subnet and virtual network
$subnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix $subnetAddress
$vnet = New-AzureRmVirtualNetwork -ResourceGroupName $resourceGroup.ResourceGroupName -Location $resourceGroup.Location `
        -Name $vnetName -AddressPrefix $vnetAddress -Subnet $subnetConfig

#Create a public IP address for the load balancer
$pipLB = New-AzureRmPublicIpAddress -Name "pipLB$(Get-Random)" -ResourceGroupName $resourceGroup.ResourceGroupName `
        -Location $resourceGroup.Location -AllocationMethod Static -DomainNameLabel $dnsNameLB

#Create front-end for the load balancer
$lbFrontEnd = New-AzureRmLoadBalancerFrontendIpConfig -Name "LB-Frontend" -PublicIpAddress $pipLB

#Create back-end for the load balancer
$lbBackEnd = New-AzureRmLoadBalancerBackendAddressPoolConfig -Name "LB-Backend"

#Create NAT rules for RDP
$inboundNATRule1= New-AzureRmLoadBalancerInboundNatRuleConfig -Name RDP1 -FrontendIpConfiguration $lbFrontEnd `
                    -Protocol TCP -FrontendPort 3441 -BackendPort 3389

$inboundNATRule2= New-AzureRmLoadBalancerInboundNatRuleConfig -Name RDP2 -FrontendIpConfiguration $lbFrontEnd `
                    -Protocol TCP -FrontendPort 3442 -BackendPort 3389

#Create TCP Health Probe
$healthProbe = New-AzureRmLoadBalancerProbeConfig -Name TCPHealthProbe -Protocol Tcp -Port 80 -IntervalInSeconds 15 -ProbeCount 2

#Create Load Balancer rule for HTTP
$lbRule1 = New-AzureRmLoadBalancerRuleConfig -Name "lbRule1" -FrontendIpConfiguration $lbFrontEnd `
            -BackendAddressPool $lbBackEnd -Probe $healthProbe -Protocol Tcp -FrontendPort 80 -BackendPort 80

#Create the Load Balancer
$loadBalancer = New-AzureRmLoadBalancer -ResourceGroupName $resourceGroup.ResourceGroupName `
                -Name $loadBalancerName -Location $resourceGroup.Location -FrontendIpConfiguration $lbFrontEnd `
                -InboundNatRule $inboundNATRule1,$inboundNatRule2 -LoadBalancingRule $lbRule1 -BackendAddressPool $lbBackEnd `
                -Probe $healthProbe

#Create a public IPs address for the VMs
$pip1 = New-AzureRmPublicIpAddress -ResourceGroupName $resourceGroup.ResourceGroupName -Location $resourceGroup.Location `
        -Name ($vmName1 + "_pip") -AllocationMethod Static -IdleTimeoutInMinutes 4 -DomainNameLabel $vmName1

$pip2 = New-AzureRmPublicIpAddress -ResourceGroupName $resourceGroup.ResourceGroupName -Location $resourceGroup.Location `
        -Name ($vmName2 + "_pip") -AllocationMethod Static -IdleTimeoutInMinutes 4 -DomainNameLabel $vmName2

# Create an inbound network security group rule for port 3389
$nsgRuleRDP = New-AzureRmNetworkSecurityRuleConfig -Name AllowRDP  -Protocol Tcp `
  -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * `
  -DestinationPortRange 3389 -Access Allow

# Create a network security group
$nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $resourceGroup.ResourceGroupName -Location $resourceGroup.Location `
        -Name $nsgName -SecurityRules $nsgRuleRDP

# Create a virtual network card and associate with public IP address and NSG
$nic1 = New-AzureRmNetworkInterface -Name $nicName1 -ResourceGroupName $resourceGroup.ResourceGroupName `
        -Location $resourceGroup.Location -SubnetId $vnet.Subnets[0].Id `
        -LoadBalancerBackendAddressPoolId $loadBalancer.BackendAddressPools[0].Id `
        -LoadBalancerInboundNatRuleId $loadBalancer.InboundNatRules[0].Id `
        -PrivateIpAddress $privateIP1 -PublicIpAddressId $pip1.Id -NetworkSecurityGroupId $nsg.Id

$nic2 = New-AzureRmNetworkInterface -Name $nicName2 -ResourceGroupName $resourceGroup.ResourceGroupName `
        -Location $resourceGroup.Location -SubnetId $vnet.Subnets[0].Id `
        -LoadBalancerBackendAddressPoolId $loadBalancer.BackendAddressPools[0].Id `
        -LoadBalancerInboundNatRuleId $loadBalancer.InboundNatRules[1].Id `
        -PrivateIpAddress $privateIP2 -PublicIpAddressId $pip2.Id -NetworkSecurityGroupId $nsg.Id 

#Create the virtual machines configuration
$vmConfig1 = New-AzureRmVMConfig -VMName $vmName1 -VMSize $vmSize -AvailabilitySetId $availabilitySet.Id | `
    Set-AzureRmVMOperatingSystem -Windows -ComputerName $vmName1 -Credential $cred | `
    Set-AzureRmVMSourceImage -PublisherName $imagePublisher -Offer $imageOffer `
    -Skus $vmImageSkus -Version latest | Add-AzureRmVMNetworkInterface -Id $nic1.Id

$vmConfig2 = New-AzureRmVMConfig -VMName $vmName2 -VMSize $vmSize -AvailabilitySetId $availabilitySet.Id | `
    Set-AzureRmVMOperatingSystem -Windows -ComputerName $vmName2 -Credential $cred | `
    Set-AzureRmVMSourceImage -PublisherName $imagePublisher -Offer $imageOffer `
    -Skus $vmImageSkus -Version latest | Add-AzureRmVMNetworkInterface -Id $nic2.Id

#Create the virtual machines
New-AzureRmVM -ResourceGroupName $resourceGroup.ResourceGroupName -Location $resourceGroup.Location -VM $vmConfig1
New-AzureRmVM -ResourceGroupName $resourceGroup.ResourceGroupName -Location $resourceGroup.Location -VM $vmConfig2

$vm1 = Get-AzureRmVM -ResourceGroupName $resourceGroup.ResourceGroupName -Name $vmName1
$vm2 = Get-AzureRmVM -ResourceGroupName $resourceGroup.ResourceGroupName -Name $vmName2

#Create storage account for DSC and custom script
$storageAccount = New-AzureRmStorageAccount -ResourceGroupName $resourceGroup.ResourceGroupName -Name $storageAccountName `
                -SkuName $storageSku -Location $resourceGroup.Location -Kind $storageKind

#Publish the configuration script into user storage
Publish-AzureRmVMDscConfiguration -ConfigurationPath .\PowerShell\iisInstall.ps1 -ResourceGroupName $resourceGroup.ResourceGroupName `
                                    -StorageAccountName $storageAccount.StorageAccountName -force
#Set the VMs to run the DSC configuration
Set-AzureRmVmDscExtension -Version 2.21 -ResourceGroupName $resourceGroup.ResourceGroupName `
                        -VMName $vm1.Name -ArchiveStorageAccountName $storageAccount.StorageAccountName `
                        -ArchiveBlobName iisInstall.ps1.zip -AutoUpdate:$true -ConfigurationName "IISInstall"

Set-AzureRmVmDscExtension -Version 2.21 -ResourceGroupName $resourceGroup.ResourceGroupName `
                        -VMName $vm2.Name -ArchiveStorageAccountName $storageAccount.StorageAccountName `
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

#Add index.html to wwwroot with custom script on VMs
Set-AzureRmVMCustomScriptExtension -ResourceGroupName $resourceGroup.ResourceGroupName `
    -VMName $vm1.Name -Location $resourceGroup.Location `
    -FileUri $scriptBlob.ICloudBlob.StorageUri.PrimaryUri.AbsoluteUri `
    -Run 'myScript.ps1' -Name myScriptExtension

Set-AzureRmVMCustomScriptExtension -ResourceGroupName $resourceGroup.ResourceGroupName `
    -VMName $vm2.Name -Location $resourceGroup.Location `
    -FileUri $scriptBlob.ICloudBlob.StorageUri.PrimaryUri.AbsoluteUri `
    -Run 'myScript.ps1' -Name myScriptExtension


If ((Invoke-WebRequest -Uri $pipLB.DnsSettings.Fqdn).StatusCode -eq "200") {

    Write-Host "Deployment seems successful. Go to http://$($pipLB.DnsSettings.Fqdn) to test the load balancing." -ForegroundColor Yellow

}

Else {

    Write-Host "Cannot reach the website. Check for errors." -ForegroundColor Red
}

<# Add load balancing rule
$lb = Get-AzureRmLoadBalancer -Name $loadBalancer.Name -ResourceGroupName $resourceGroup.ResourceGroupName

$lb | Add-AzureRmLoadBalancerRuleConfig -Name "lbRule2" -FrontendIPConfiguration $lb.FrontendIpConfigurations[0] `
                -Protocol "Tcp" -FrontendPort 443 -BackendPort 443 -BackendAddressPool $lb.BackendAddressPools[0] -Probe $healthProbe
$lb | Set-AzureRmLoadBalancer
#>

<#
    The resource group can be deleted to remove all resources deployed when done.
#>
#Remove-AzureRmResourceGroup -Name $resourceGroup.ResourceGroupName -Force
