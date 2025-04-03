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
    # Check if diagnostic settings with the name "Sentinel" is enabled
    $diagnosticSetting = Get-AzDiagnosticSetting -ResourceId "/subscriptions/$subscriptionId" | Where-Object { $_.Name -contains $SentinelDiagnosticSettingName }

    if ($diagnosticSetting) {
        Write-Output "Sentinel diagnostic setting already exists for subscription: $subscriptionId"
    } else {
        Write-Output "Enabling Sentinel diagnostic setting for subscription: $subscriptionId"


        # Enable diagnostic settings with the name "Sentinel"
        New-AzDiagnosticSetting -ResourceId "/subscriptions/$subscriptionId" -Name $SentinelInstance$SentinelDiagnosticSettingName `
            -WorkspaceId $SentinelInstanceID `
            -Log $logSettingsAzureActivity
    }
}