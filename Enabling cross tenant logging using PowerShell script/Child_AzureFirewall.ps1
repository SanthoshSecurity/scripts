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

    # Get all firewalls in the subscription
    $firewalls = Get-AzFirewall

    foreach ($firewall in $firewalls) {
        $resourceId = $firewall.Id
        Write-Output "Processing Firewall: $($firewall.Name) in subscription: $subscriptionId"

        # Check if diagnostic settings with the name "Sentinel" is enabled
        $diagnosticSetting = Get-AzDiagnosticSetting -ResourceId $resourceId | Where-Object { $_.Name -contains $SentinelDiagnosticSettingName }

        if ($diagnosticSetting) {
            Write-Output "Firewall diagnostic setting already exists for Firewall: $($firewall.Name) in subscription: $subscriptionId"
        } else {
            Write-Output "Enabling diagnostic setting for Firewall: $($firewall.Name) in subscription: $subscriptionId"



            # Enable diagnostic settings with the name "Sentinel"
            New-AzDiagnosticSetting -ResourceId $resourceId -Name $SentinelDiagnosticSettingName `
                -WorkspaceId $SentinelInstanceID `
                -Log $logSettingsAzurerFirewall
        }
    }
}