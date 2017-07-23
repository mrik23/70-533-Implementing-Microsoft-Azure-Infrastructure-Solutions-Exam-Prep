#Azure PowerShell v2
#Check documentation https://docs.microsoft.com/en-us/powershell/azure/active-directory/install-adv2?view=azureadps-2.0

Import-Module AzureRM
$credential = Get-Credential
Login-AzureRmAccount -Credential $credential

#Get all cmdlets related to Azure Storage
Get-Command *storage* -Module AzureRM

#Set variables
$location = "eastus" #Find the choice of location with 'Get-AzureRmLocation | select location'
$resourceGroupName = "myResourceGroup" + (Get-Random -Maximum 99).ToString()
$storageAccountName = ("myStorageAccount" + (Get-Random -Maximum 99999).ToString()).ToLower()
$storageSku = "Standard_LRS" #Choice between Standard_LRS, Standard_ZRS, Standard_GRS, Standard_RAGRS and Premium_LRS
$storageKind = "Storage" #Choice between BlobStorage and Storage
$blobStorageAccountName = ("myBlobStorageAccount" + (Get-Random -Maximum 99999).ToString()).ToLower()
$blobStorageKind = "BlobStorage"
$blobStorageAccessTier = "Hot" #Only for BlobStorage kind. Choice between Hot and Cool

#Create the resource group to hold Storage account
$resourceGroup = New-AzureRmResourceGroup -Name $resourceGroupName -Location $location

$storageAccount = New-AzureRmStorageAccount -ResourceGroupName $resourceGroup.ResourceGroupName -Name $storageAccountName `
                -SkuName $storageSku -Location $resourceGroup.Location -Kind $storageKind

$blobStorageAccount = New-AzureRmStorageAccount -ResourceGroupName $resourceGroup.ResourceGroupName -Name $blobStorageAccountName `
                -SkuName $storageSku -Location $resourceGroup.Location -Kind $blobStorageKind -AccessTier $blobStorageAccessTier `
                -EnableEncryptionService $true -EnableHttpsTrafficOnly $true