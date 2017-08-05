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
$storageAccountName = ("myStorageAccount" + (Get-Random -Maximum 999).ToString()).ToLower()
$storageSku = "Standard_LRS" #Choice between Standard_LRS, Standard_ZRS, Standard_GRS, Standard_RAGRS and Premium_LRS
$storageKind = "Storage" #Choice between BlobStorage and Storage
$blobStorageAccountName = ("myBlobStorageAccount" + (Get-Random -Maximum 999).ToString()).ToLower()
$blobStorageKind = "BlobStorage"
$blobStorageAccessTier = "Hot" #Only for BlobStorage kind. Choice between Hot and Cool
$fileShareName = ("myFileShare" + (Get-Random -Maximum 99).ToString()).ToLower()
$containerName = ("myContainer" + (Get-Random -Maximum 99).ToString()).ToLower()
$containerPermission = "Off" #Choice Between Blob, Container, Off

#Create the resource group to hold Storage account
$resourceGroup = New-AzureRmResourceGroup -Name $resourceGroupName -Location $location

#Create the storage account
$storageAccount = New-AzureRmStorageAccount -ResourceGroupName $resourceGroup.ResourceGroupName -Name $storageAccountName `
                -SkuName $storageSku -Location $resourceGroup.Location -Kind $storageKind

#Get the storage account keys
$storageAccountKey = Get-AzureRmStorageAccountKey -ResourceGroupName $resourceGroup.ResourceGroupName `
                    -Name $storageAccount.StorageAccountName

#Set the storage account context
$storageContext = New-AzureStorageContext -StorageAccountName $storageAccount.StorageAccountName `
                -StorageAccountKey ($storageAccountKey | Where-Object -Property "KeyName" -Like "key1").Value

#Create a new file in the storage account
$fileShare = New-AzureStorageShare -Name $fileShareName -Context $storageContext

#Set the file share storage quota
Set-AzureStorageShareQuota -ShareName $fileShare.Name -Quota 10 -Context $storageContext

#Create a directory in the file share
$fileShareDirectory = New-AzureStorageDirectory -Share $fileShare -Path "Test"

#Upload file to Test directory
Set-AzureStorageFileContent -Share $fileShare -Source .\test.txt -Path $fileShareDirectory.Name

#List files in Test directory
Get-AzureStorageFile -Share $fileShare -Path "Test" | Get-AzureStorageFile

#Download file from Test directory
Get-AzureStorageFileContent -Share $fileShare -Path "Test/test.txt" -Destination .\test-download.txt


#Create Blob Storage account
$blobStorageAccount = New-AzureRmStorageAccount -ResourceGroupName $resourceGroup.ResourceGroupName -Name $blobStorageAccountName `
                -SkuName $storageSku -Location $resourceGroup.Location -Kind $blobStorageKind -AccessTier $blobStorageAccessTier `
                -EnableEncryptionService "Blob" -EnableHttpsTrafficOnly $true

#Get the storage account keys
$blobStorageAccountKey = Get-AzureRmStorageAccountKey -ResourceGroupName $resourceGroup.ResourceGroupName `
                    -Name $blobStorageAccount.StorageAccountName

#Set the storage account context
$blobStorageContext = New-AzureStorageContext -StorageAccountName $blobStorageAccount.StorageAccountName `
                -StorageAccountKey ($blobStorageAccountKey | Where-Object -Property "KeyName" -Like "key1").Value

#Create a container in the blob storage account
$container = New-AzureStorageContainer -Name $containerName -Permission $containerPermission -Context $blobStorageContext

#Upload file to blob storage container
Set-AzureStorageBlobContent -Container $container.Name -File ".\test.txt" -Blob "test.txt" -Context $blobStorageContext

#Download file from blob storage container
Get-AzureStorageBlobContent -Container $container.Name -Blob "test.txt" -Destination ".\test-download.txt" -Context $blobStorageContext

#Remove the resource group
Remove-AzureRmResourceGroup -Name $resourceGroup.ResourceGroupName -Force