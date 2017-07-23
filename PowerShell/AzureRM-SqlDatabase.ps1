#Azure PowerShell v2
#Check documentation https://docs.microsoft.com/en-us/powershell/azure/active-directory/install-adv2?view=azureadps-2.0

Import-Module AzureRM
$credential = Get-Credential
Login-AzureRmAccount -Credential $credential

#Get all cmdlets related to Azure SQL Database
Get-Command *sql* -Module AzureRM

#Set variables
$location = "eastus" #Find the choice of location with 'Get-AzureRmLocation | select location'
$resourceGroupName = "myResourceGroup" + (Get-Random -Maximum 99).ToString()
$sqlServerName = ("mySqlServer" + (Get-Random -Maximum 9999).ToString()).ToLower()
$sqlServerCredentials = Get-Credential #Username cannot be admin
$firewallRuleName = "AllowedIps"
$startip = "10.0.0.1"
$endip = "10.0.0.254"
$dbName = "mydb" + (Get-Random -Maximum 99).ToString()
$serviceTier= "Standard" #Choice between Basic, Standard, Premium, PremiumRS
$performanceLevel = "S0" #Choice between S0 S1 S2 S3; P1 P2 P4 P6 P11 P15; PRS1 PRS2 PRS4 PRS6

#Create the resource group to hold SQL server and database
$resourceGroup = New-AzureRmResourceGroup -Name $resourceGroupName -Location $location

#Create the SQL Server
$sqlServer = New-AzureRmSqlServer -ServerName $sqlServerName -Location $resourceGroup.Location `
            -ResourceGroupName $resourceGroup.ResourceGroupName -SqlAdministratorCredentials $sqlServerCredentials

# Create a server firewall rule that allows access from the specified IP range
$serverfirewallrule = New-AzureRmSqlServerFirewallRule -ResourceGroupName $resourceGroup.ResourceGroupName`
    -ServerName $sqlServer.ServerName `
    -FirewallRuleName $firewallRuleName -StartIpAddress $startip -EndIpAddress $endip

#Create the SQL database
$db = New-AzureRmSqlDatabase -DatabaseName $dbName -Edition $serviceTier -RequestedServiceObjectiveName $performanceLevel `
        -ServerName $sqlServer.ServerName -ResourceGroupName $resourceGroup.ResourceGroupName

#Change the performance level of the database
$db = Set-AzureRmSqlDatabase -DatabaseName $db.DatabaseName -RequestedServiceObjectiveName "S1" `
        -ServerName $sqlServer.ServerName -ResourceGroupName $resourceGroup.ResourceGroupName

#Get all databases in the SQL server
$dbs = Get-AzureRmSqlDatabase -ServerName $sqlServer.ServerName -ResourceGroupName $resourceGroup.ResourceGroupName

#Remove all databases
$dbs | Remove-AzureRmSqlDatabase -ServerName $sqlServer.ServerName -ResourceGroupName $resourceGroup.ResourceGroupName

#Remove the SQL server
Remove-AzureRmSqlServer -ServerName $sqlServer.ServerName -ResourceGroupName $resourceGroup.ResourceGroupName

#Remove the resource group
Remove-AzureRmResourceGroup -Name $resourceGroup.ResourceGroupName -Force
