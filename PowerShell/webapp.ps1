Import-Module AzureRM

Login-AzureRmAccount

New-AzureRmResourceGroup -Name 'webapp-70533-rg' -Location 'southeast asia'

New-AzureRmAppServicePlan -Location "southeast asia" -Tier Free -ResourceGroupName "webapp-70533-rg" -Name "webapp-70533-asp"

New-AzureRmWebApp -ResourceGroupName webapp-70533-rg -Name "webapp-70533" -Location "southeast asia" -AppServicePlan "webapp-70533-asp"
