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

    # Get all NSGs in the subscription
    $nsgs = Get-AzNetworkSecurityGroup

    foreach ($nsg in $nsgs) {
        $resourceId = $nsg.Id
        Write-Output "Processing NSG: $($nsg.Name) in subscription: $subscriptionId"

        # Check if diagnostic settings with the name "NSGDiagnostics" is enabled
        $diagnosticSetting = Get-AzDiagnosticSetting -ResourceId $resourceId | Where-Object { $_.Name -contains $SentinelDiagnosticSettingName }

        if ($diagnosticSetting) {
            Write-Output "NSG diagnostic setting already exists for NSG: $($nsg.Name) in subscription: $subscriptionId"
        } else {
            Write-Output "Enabling NSG diagnostic setting for NSG: $($nsg.Name) in subscription: $subscriptionId"



            # Enable diagnostic settings with the name "NSGDiagnostics"
            New-AzDiagnosticSetting -ResourceId $resourceId -Name $SentinelDiagnosticSettingName `
                -WorkspaceId $SentinelInstanceID `
                -Log $logSettingsNSG
        }
    }
}