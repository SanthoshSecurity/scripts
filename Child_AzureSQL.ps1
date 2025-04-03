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

    # Get all SQL databases in the subscription
    $sqlServers = Get-AzSqlServer
    foreach ($sqlServer in $sqlServers) {
        $sqlDatabases = Get-AzSqlDatabase -ServerName $sqlServer.ServerName -ResourceGroupName $sqlServer.ResourceGroupName

        foreach ($sqlDatabase in $sqlDatabases) {
            $resourceId = $sqlDatabase.ResourceId
            Write-Output "Processing SQL Database: $($sqlDatabase.DatabaseName) in subscription: $subscriptionId"

            # Check if diagnostic settings with the name "Sentinel" is enabled
            $diagnosticSetting = Get-AzDiagnosticSetting -ResourceId $resourceId | Where-Object { $_.Name -contains $SentinelDiagnosticSettingName }

            if ($diagnosticSetting) {
                Write-Output "SQL Database diagnostic setting already exists for Database: $($sqlDatabase.DatabaseName) in subscription: $subscriptionId"
            } else {
                Write-Output "Enabling SQL Database diagnostic setting for Database: $($sqlDatabase.DatabaseName) in subscription: $subscriptionId"



                # Enable diagnostic settings with the name "Sentinel"
                New-AzDiagnosticSetting -ResourceId $resourceId -Name $SentinelDiagnosticSettingName `
                    -WorkspaceId $SentinelInstanceID `
                    -Log $logSettingsAzureSQL
            }
        }
    }
}