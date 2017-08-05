#Azure PowerShell v2
#Check documentation https://docs.microsoft.com/en-us/powershell/azure/active-directory/install-adv2?view=azureadps-2.0

Import-Module AzureRM
$credential = Get-Credential
Login-AzureRmAccount -Credential $credential

$location = "eastus" #Find the choice of location with 'Get-AzureRmLocation | select location'
$resourceGroupName = "myResourceGroup" + (Get-Random -Maximum 99).ToString()
$appServicePlanName = "myAppServicePlan" + (Get-Random -Maximum 99).ToString()
$webAppName = "myapp" + (Get-Random -Maximum 99999).ToString()
$tier = "Standard" #Choice between Free, Shared, Basic, Standard or Premium
$size = "Small" #Choice between Small, Medium, Large , ExtraLarge (Only for Premium tier). No choice for free and shared tiers.

#Create the resource group for the app service plan and web app
$resourceGroup = New-AzureRmResourceGroup -Name $resourceGroupName -Location $location

#Create the app service plan to host the web app
$appServicePlan = New-AzureRmAppServicePlan -Location $resourceGroup.Location -Tier $tier `
                -ResourceGroupName $resourceGroup.ResourceGroupName -Name $appServicePlanName -WorkerSize $size

#Create the web app in the app service plan and resource group created
$webApp = New-AzureRmWebApp -name $webAppName -ResourceGroupName $resourceGroup.ResourceGroupName `
        -Location $resourceGroup.Location -AppServicePlan $appServicePlanName

#Check the web app created
Get-AzureRmWebApp -ResourceGroupName $resourceGroup.ResourceGroupName -Name $webAppName

#Stop web app (not the app service) 
Stop-AzureRmWebApp -ResourceGroupName $resourceGroup.ResourceGroupName -Name $webApp.Name

#Start web app
Start-AzureRmWebApp -ResourceGroupName $resourceGroup.ResourceGroupName -Name $webApp.Name

#Change an existing web app
$webApp = Set-AzureRmWebApp -ResourceGroupName $resourceGroup.ResourceGroupName -Name $webApp.Name `
                -HttpLoggingEnabled $true

#Add app settings to an existing web app.
#It's important to retrieve the current settings before adding the new one, else it gets deleted.
$webAppSettings = @{}
$webAppExistingSettings = $webApp.SiteConfig.AppSettings
ForEach ($webAppSetting in $webAppExistingSettings) {
        $webAppSettings[$webAppSetting.Name]= $webAppSetting.Value
}
$webAppSettings.Add("SECRET", "password")
$webApp = Set-AzureRmWebApp -ResourceGroupName $resourceGroup.ResourceGroupName -Name $webApp.Name `
                -HttpLoggingEnabled $true -AppSettings $webAppSettings

get-command *settings* -Module AzureRM

Get-AzureRmResourceProvider | Select-Object ProviderNamespace