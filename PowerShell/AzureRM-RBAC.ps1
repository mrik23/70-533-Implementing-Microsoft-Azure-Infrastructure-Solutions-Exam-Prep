#Azure PowerShell v2
#Check documentation https://docs.microsoft.com/en-us/powershell/azure/active-directory/install-adv2?view=azureadps-2.0

Import-Module AzureRM
$credential = Get-Credential
Login-AzureRmAccount -Credential $credential

get-command *role* -Module AzureRM.Resources

#Get all built-in roles
Get-AzureRmRoleDefinition | Where-Object isCustom -EQ $false | select Name, description, isCustom | Format-Table

#Get one particular role
$role = Get-AzureRmRoleDefinition | Where-Object Name -EQ "Virtual Machine Contributor"

#Export the role as a JSON file
$role.AssignableScopes.Clear()
$role.AssignableScopes.Add("/subscriptions/" + (Get-AzureRmSubscription)[0].Id)
$role | ConvertTo-Json | Out-File -FilePath ./role.json

#Create a custom role directly in the object
$customRole = Get-AzureRmRoleDefinition | Where-Object Name -EQ "Virtual Machine Contributor"
$customRole.Name = "Virtual Machine Reader"
$customRole.Id  = $null
$customRole.IsCustom = $true
$customRole.Description = "Can read the virtual machines information"
$customRole.Actions.Clear()
$customRole.Actions.Add("Microsoft.Compute/*/read")
$customRole.NotActions.Clear()
$customRole.AssignableScopes.Clear()
$customRole.AssignableScopes.Add("/subscriptions/" + (Get-AzureRmSubscription)[0].Id)

#Add the custom role from the object
New-AzureRmRoleDefinition -Role $customRole

#Add the custom role from the JSON file
New-AzureRmRoleDefinition -InputFile ./role-custom.json

#Get all custom roles
Get-AzureRmRoleDefinition | Where-Object isCustom -EQ $true | select Name, description, isCustom | Format-Table

#Modify an existing custom role
$customRoleMod = Get-AzureRmRoleDefinition "Virtual Machine Reader"
$customRoleMod.Actions.Add("Microsoft.Network/virtualNetworks/read")
Set-AzureRmRoleDefinition -Role $customRoleMod

#Get the resource provider namespace to edit your custom role
Get-AzureRMResourceProvider -ListAvailable | Select ProviderNamespace, RegistrationState | Format-Table

#Get the actions for a resource provider 
Get-AzureRMProviderOperation "Microsoft.Compute/*" | Format-Table Operation , Description

#Check the Role Assigned on a resource group
Get-AzureRmRoleAssignment -ResourceGroupName (Get-AzureRmResourceGroup)[0].ResourceGroupName

#Get the Role Assigned to a user
Get-AzureRmRoleAssignment -SignInName (Get-AzureRmSubscription)[0].ExtendedProperties["Account"]
