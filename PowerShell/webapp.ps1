#Azure PowerShell v2
#Check documentation https://docs.microsoft.com/en-us/powershell/azure/active-directory/install-adv2?view=azureadps-2.0

Import-Module AzureRM
Login-AzureRmAccount

$resourceGroup = New-AzureRmResourceGroup -Name "myResourceGroup" -Location "East US"

get-command *appservice*

$appServicePlan = New-AzureRmAppServicePlan -Location $resourceGroup.Location -Tier Free `
                -ResourceGroupName $resourceGroup.ResourceGroupName -Name "myAppServicePlan"

$webApp = New-AzureRmWebApp -name "myWebApp" -ResourceGroupName $resourceGroup.ResourceGroupName `
        -Location "southeast asia" -AppServicePlan "webapp-70533-asp"
