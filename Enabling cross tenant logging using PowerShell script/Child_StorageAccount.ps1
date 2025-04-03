# Import the configuration file
. "C:\Users\santhoshg\Desktop\Powershell scripts\config.ps1"

# Authenticate using the service principal
$secureClientSecret = ConvertTo-SecureString -String $clientSecret -AsPlainText -Force
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $clientId, $secureClientSecret

Connect-AzAccount -ServicePrincipal -Tenant $tenantId -Credential $credential

# List all subscriptions in the tenant
$subscriptions = Get-AzSubscription


# Loop through each subscription
foreach ($subscription in $subscriptions) {
    $subscriptionId = $subscription.Id

    # Skip the excluded subscription
    if ($subscriptionId -eq $excludedSubscriptionId) {
        Write-Output "Skipping excluded subscription: $subscriptionId"
        continue
    }
    Write-Output "Processing subscription: $subscriptionId"

    # Set the context to the current subscription
    Set-AzContext -SubscriptionId $subscriptionId

    # List all storage accounts in the subscription
    $storageAccounts = Get-AzStorageAccount 

    foreach ($storageAccount in $storageAccounts) {
        $storageAccountId = $storageAccount.Id
        $storageAccountName = $storageAccount.StorageAccountName

        # Check if diagnostic settings are enabled
        $diagnosticSetting = Get-AzDiagnosticSetting -ResourceId $storageAccountId | Where-Object { $_.Name -contains $SentinelDiagnosticSettingName }

        if ($diagnosticSetting) {
            Write-Output "Diagnostic setting already exists for storage account: $($storageAccountName)"
        } else {
            Write-Output "No diagnostic setting found for storage account: $($storageAccountName)"
            

            New-AzDiagnosticSetting -ResourceId $storageAccountId -Name $SentinelDiagnosticSettingName `
                -WorkspaceId $SentinelInstanceID `
                 -Metric $StorageAccountmetricSettings
        }
        
         # Resource IDs for each storage service type under the storage account
         $blobServiceResourceId = "$storageAccountId/blobServices/default"
         $queueServiceResourceId = "$storageAccountId/queueServices/default"
         $fileServiceResourceId = "$storageAccountId/fileServices/default"
         $tableServiceResourceId = "$storageAccountId/tableServices/default"


         $serviceTypes = @(
            @{ ResourceId = $blobServiceResourceId; Name = "BlobDiagnostics" },
            @{ ResourceId = $queueServiceResourceId; Name = "QueueDiagnostics" },
            @{ ResourceId = $fileServiceResourceId; Name = "FileDiagnostics" },
            @{ ResourceId = $tableServiceResourceId; Name = "TableDiagnostics" }
        )
       
        foreach ($service in $serviceTypes) {
         
        
        $diagnosticSetting = Get-AzDiagnosticSetting -ResourceId $service.ResourceId | Where-Object { $_.Name -contains $SentinelDiagnosticSettingName }

        if ($diagnosticSetting) {
            Write-Output "$($service.Name) setting already exists for storage account: $($storageAccount.StorageAccountName)"
        } else {
            Write-Output "no $($service.Name) setting found for storage account: $($storageAccount.StorageAccountName)"



            # Create an array of log settings objects for each category
            $logSettings = @()
            foreach ($category in $StorageAccountlogCategories) {
                $logSettings += New-AzDiagnosticSettingLogSettingsObject -Category $category -Enabled $true
            }

            New-AzDiagnosticSetting -ResourceId $service.ResourceId -Name $SentinelDiagnosticSettingName `
                -WorkspaceId $SentinelInstanceID `
                 -Metric $metricSettings -Log $LogSettings
        }
    }
   
    }
}