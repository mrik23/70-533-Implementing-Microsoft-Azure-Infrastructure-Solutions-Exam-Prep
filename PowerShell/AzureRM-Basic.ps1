#Azure PowerShell v2
#Check documentation https://docs.microsoft.com/en-us/powershell/azure/active-directory/install-adv2?view=azureadps-2.0

Import-Module AzureRM
$credential = Get-Credential
Login-AzureRmAccount -Credential $credential

#Check the version of AzureRM module
Get-Module AzureRM

Update-Module AzureRM

#List all Azure RM cmdlets
get-command * -Module AzureRm

#List all Azure RM VM cmdlets
get-command * -Module AzureRM.Compute

#List all Azure SQL Database cmdlets
get-command * -Module AzureRM.Sql

#List all Azure Location (region)
Get-AzureRmLocation

#List all resource providers enabled
Get-AzureRmResourceProvider -ListAvailable

#Register a resource provider namespace
Register-AzureRmResourceProvider -ProviderNamespace "Microsoft.KeyVault"



