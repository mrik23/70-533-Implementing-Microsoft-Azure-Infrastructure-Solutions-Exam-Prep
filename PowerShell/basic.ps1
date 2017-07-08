Import-Module AzureRM

Login-AzureRmAccount

New-AzureRmResourceGroup -Name '70533-test-rg' -Location 'southeast asia'

Remove-AzureRmResourceGroup -Name '70533-test-rg' -Force

