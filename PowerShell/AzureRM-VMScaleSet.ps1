#Azure PowerShell v2
#Check documentation https://docs.microsoft.com/en-us/powershell/azure/active-directory/install-adv2?view=azureadps-2.0

Import-Module AzureRM
$credential = Get-Credential
Login-AzureRmAccount -Credential $credential

$location = "eastus" #Find the choice of location with 'Get-AzureRmLocation | select location'
$rgName = "myResourceGroup" + (Get-Random -Maximum 99).ToString()
$vmSize = "Standard_A1" #Find VM size options with 'Get-AzureRmVMSize -location $location'
$vmssCapacity = 3
$imagePublisher = "MicrosoftWindowsServer" #Find with 'Get-AzureRmVMImagePublisher -Location $location'
$imageOffer = "WindowsServer" #Find with 'Get-AzureRmVMImageOffer -Location $location -PublisherName $imagePublisher'
$vmImageSkus = "2012-R2-Datacenter" #Find with 'Get-AzureRmVMImageSku -Location $location -PublisherName $imagePublisher -Offer $imageOffer'
$osDiskCache = "None" #Choice between None, Read, ReadWrite
$password = "myPasswordIsS3cure"
$user = "myAdminUser"

#Create resource group
$resourceGroup = New-AzureRmResourceGroup -ResourceGroupName $rgName -Location $location

#Create a public IP address
$publicIP = New-AzureRmPublicIpAddress -ResourceGroupName $resourceGroup.ResourceGroupName `
            -Location $resourceGroup.Location -AllocationMethod Static -Name "myPublicIP" `
            -DomainNameLabel ($resourceGroup.ResourceGroupName + (Get-Random -Maximum 9999).ToString()).tolower() 

#Create a frontend and backend IP pool for the load balancer
$frontendIP = New-AzureRmLoadBalancerFrontendIpConfig -Name "myFrontEndPool" -PublicIpAddress $publicIP
$backendPool = New-AzureRmLoadBalancerBackendAddressPoolConfig -Name "myBackEndPool"

#Create the load balancer
$lb = New-AzureRmLoadBalancer -ResourceGroupName $resourceGroup.ResourceGroupName `
        -Name "myLoadBalancer" -Location $resourceGroup.Location `
        -FrontendIpConfiguration $frontendIP -BackendAddressPool $backendPool

#Create a load balancer health probe on port 80
Add-AzureRmLoadBalancerProbeConfig -Name "myHealthProbe" -LoadBalancer $lb -Protocol "tcp" -Port 80 -IntervalInSeconds 15 -ProbeCount 2

#Create a load balancer rule to distribute traffic on port 80
Add-AzureRmLoadBalancerRuleConfig -Name "myLoadBalancerRule" -LoadBalancer $lb `
        -FrontendIpConfiguration $lb.FrontendIpConfigurations[0] -BackendAddressPool $lb.BackendAddressPools[0] `
        -Protocol "tcp" -FrontendPort 80 -BackendPort 80 -Probe $lb.Probes[0]

#Update the load balancer configuration
Set-AzureRmLoadBalancer -LoadBalancer $lb

#Create a config object for the VM scale set
$vmssConfig = New-AzureRmVmssConfig -Location $resourceGroup.Location -SkuCapacity $vmssCapacity `
            -SkuName $vmSize -UpgradePolicyMode "Automatic"

#Define the script for your Custom Script Extension to run
$publicSettings = @{
    "fileUris" = (,"https://raw.githubusercontent.com/iainfoulds/azure-samples/master/automate-iis.ps1");
    "commandToExecute" = "powershell -ExecutionPolicy Unrestricted -File automate-iis.ps1"
}

#Use Custom Script Extension to install IIS and configure basic website
Add-AzureRmVmssExtension -VirtualMachineScaleSet $vmssConfig -Name "myCustomScript" -Publisher "Microsoft.Compute" `
                        -Type "CustomScriptExtension" -Setting $publicSettings -TypeHandlerVersion "1.9"

# Reference a virtual machine image from the gallery
Set-AzureRmVmssStorageProfile $vmssConfig -ImageReferencePublisher $imagePublisher -ImageReferenceOffer $imageOffer `
                            -ImageReferenceSku $vmImageSkus -ImageReferenceVersion "latest" -OsDiskCaching $osDiskCache

#Set up information for authenticating with the virtual machine
Set-AzureRmVmssOsProfile $vmssConfig -AdminUsername $user -AdminPassword $password -ComputerNamePrefix "myVM"

#Create the virtual network resources
$subnet = New-AzureRmVirtualNetworkSubnetConfig -Name "mySubnet" -AddressPrefix 10.0.0.0/24

$vnet = New-AzureRmVirtualNetwork -ResourceGroupName $resourceGroup.ResourceGroupName `
        -Name "myVnet" -Location $resourceGroup.Location -AddressPrefix 10.0.0.0/16 -Subnet $subnet

$ipConfig = New-AzureRmVmssIpConfig -Name "myIPConfig" -LoadBalancerBackendAddressPoolsId $lb.BackendAddressPools[0].Id `
            -SubnetId $vnet.Subnets[0].Id

#Attach the virtual network to the config object
Add-AzureRmVmssNetworkInterfaceConfiguration -VirtualMachineScaleSet $vmssConfig -Name "network-config" `
                                            -Primary $true -IPConfiguration $ipConfig

#Create the VM scale set
New-AzureRmVmss -ResourceGroupName $resourceGroup.ResourceGroupName -Name "myScaleSet" -VirtualMachineScaleSet $vmssConfig

#Get the new VM scale set
$vmss = Get-AzureRmVmss -ResourceGroupName $resourceGroup.ResourceGroupName -VMScaleSetName "myScaleSet"

#Create Auto Scaling Rules
$rule1 = New-AzureRmAutoscaleRule -MetricName "Percentage CPU" -MetricResourceId $vmss.Id `
        -Operator GreaterThan -MetricStatistic Average -Threshold 60 -TimeGrain 00:01:00 -TimeWindow 00:10:00 `
        -ScaleActionCooldown 00:10:00 -ScaleActionDirection Increase -ScaleActionValue 1

$rule2 = New-AzureRmAutoscaleRule -MetricName "Percentage CPU" -MetricResourceId $vmss.Id `
        -Operator LessThan -MetricStatistic Average -Threshold 30 -TimeGrain 00:01:00 -TimeWindow 00:10:00 `
        -ScaleActionCooldown 00:10:00 -ScaleActionDirection Decrease -ScaleActionValue 1

#Create Auto Scaling Profile
$profile1 = New-AzureRmAutoscaleProfile -DefaultCapacity 2 -MaximumCapacity 10 -MinimumCapacity 2 -Rules $rule1,$rule2 -Name "My_Profile"

#Add the Auto Scaling Profile to the VMSS
Add-AzureRmAutoscaleSetting -Location $resourceGroup.Location -Name "MyScaleVMSSSetting" `
                            -ResourceGroup $resourceGroup.ResourceGroupName `
                            -TargetResourceId $vmss.id -AutoscaleProfiles $profile1

<#
    The resource group can be deleted to remove all resources deployed when done.
#>
#Remove-AzureRmResourceGroup -Name $resourceGroup.ResourceGroupName -Force
