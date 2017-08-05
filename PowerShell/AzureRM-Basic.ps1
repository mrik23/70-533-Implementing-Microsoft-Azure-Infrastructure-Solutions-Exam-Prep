#Azure PowerShell v2
#Check documentation https://docs.microsoft.com/en-us/powershell/azure/active-directory/install-adv2?view=azureadps-2.0

Import-Module AzureRM
$credential = Get-Credential
Login-AzureRmAccount -Credential $credential

#List all Azure RM cmdlets
get-command *azurerm*

get-command * -Module AzureRM.Sql

#List all Azure Location (region)
Get-AzureRmLocation

