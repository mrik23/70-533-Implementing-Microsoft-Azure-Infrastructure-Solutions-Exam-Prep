Login-AzureRmAccount

#Check the existing resource groups 
Get-AzureRmResourceGroup

#set variables
$rgName = "myResourceGroup"
$vmName = "myVM"
$dataDiskName = $vmName.ToLower() + "_datadisk01"
$availabilitySetName = "myAS"
$nicName = $vmName.ToLower() + "_nic01"
$ipAddress = "10.0.0.5"

#Get the resouce group object
$resourceGroup = Get-AzureRmResourceGroup -name $rgName

#Get the vNet in this resource group
$vNet = Get-AzureRmVirtualNetwork -ResourceGroupName $resourceGroup.ResourceGroupName

#Find and set the VM size
Get-AzureRmVMSize -Location $resourceGroup.Location
$vmSize = "Basic_A1"

#Find and set the image publisher
Get-AzureRmVMImagePublisher -Location $resourceGroup.Location
$imagePublisher = "MicrosoftWindowsServer"

#Find and set the image offer
Get-AzureRmVMImageOffer -Location $resourceGroup.Location -PublisherName $imagePublisher
$imageOffer = "WindowsServer"

Get-AzureRmVMImageSku -Location $resourceGroup.Location -PublisherName $imagePublisher -Offer $imageOffer

$vmImageSkus = "2012-R2-Datacenter"


# Define a credential object
$cred = Get-Credential

#Create the netword adapter for the VM and assign static IP
if ((Test-AzureRmPrivateIPAddressAvailability -VirtualNetwork $vNet -IPAddress $ipAddress).Available -eq $true) {

    # Create a virtual network card and associate with public IP address and NSG
        $nic = New-AzureRmNetworkInterface -Name $nicName `
        -ResourceGroupName $resourceGroup.ResourceGroupName -Location $resourceGroup.Location `
        -SubnetId $vNet.Subnets[0].Id -PrivateIpAddress $ipAddress


}

else {

    Write-Host "Private IP address is in used already!"


}


#Create the avaibility set for the VM
$availabilitySet = New-AzureRmAvailabilitySet -Name $availabilitySetName -ResourceGroupName $resourceGroup.ResourceGroupName -Location $resourceGroup.Location -Sku "Aligned" -PlatformFaultDomainCount 2 -PlatformUpdateDomainCount 5

#Create a data disk for the VM
$dataDiskConfig = New-AzureRmDiskConfig -AccountType StandardLRS -Location $resourceGroup.Location -CreateOption Empty -DiskSizeGB 32
$dataDisk = New-AzureRmDisk -DiskName $dataDiskName -Disk $dataDiskConfig -ResourceGroupName $resourceGroup.ResourceGroupName



# Create a virtual machine configuration
$vmConfig = New-AzureRmVMConfig -VMName $vmName -VMSize $vmSize -AvailabilitySetId $availabilitySet.Id | `
    Set-AzureRmVMOperatingSystem -Windows -ComputerName $vmName -Credential $cred | `
    Set-AzureRmVMSourceImage -PublisherName $imagePublisher -Offer $imageOffer `
    -Skus $vmImageSkus -Version latest | Add-AzureRmVMNetworkInterface -Id $nic.Id | `    Add-AzureRmVMDataDisk -Name $dataDiskName -Lun 1 -CreateOption Attach -ManagedDiskId $dataDisk.Id

New-AzureRmVM -ResourceGroupName $resourceGroup.ResourceGroupName -Location $resourceGroup.Location -VM $vmConfig

