#ServicePrincipalDetails
$tenantId = "XXX"
$clientId = "XXX"
$clientSecret = "XXX"

$SentinelDiagnosticSettingName = "Sentinel"
$SentinelInstanceID = "/subscriptions/XXX/resourceGroups/XXX/providers/Microsoft.OperationalInsights/workspaces/XXX"

# Define the subscription ID to exclude
$excludedSubscriptionId = "XXX"

#AzureActivityLogging

# Define log settings objects for each category
$adminLogSettings = New-AzDiagnosticSettingLogSettingsObject -Category "Administrative" -Enabled $true
$securityLogSettings = New-AzDiagnosticSettingLogSettingsObject -Category "Security" -Enabled $true
$serviceHealthLogSettings = New-AzDiagnosticSettingLogSettingsObject -Category "ServiceHealth" -Enabled $true
$AlertLogSettings = New-AzDiagnosticSettingLogSettingsObject -Category "Alert" -Enabled $true
$RecommendationLogSettings = New-AzDiagnosticSettingLogSettingsObject -Category "Recommendation" -Enabled $true
$PolicyLogSettings = New-AzDiagnosticSettingLogSettingsObject -Category "Policy" -Enabled $true
$AutoscaleLogSettings = New-AzDiagnosticSettingLogSettingsObject -Category "Autoscale" -Enabled $true
$ResourceHealthLogSettings = New-AzDiagnosticSettingLogSettingsObject -Category "ResourceHealth" -Enabled $true

$logSettingsAzureActivity = @(
    $adminLogSettings,
    $securityLogSettings,
    $serviceHealthLogSettings,
    $AlertLogSettings,
    $RecommendationLogSettings
)
#KeyVault
 # Create log settings objects for each category
$auditLogSettingsKeyVault = New-AzDiagnosticSettingLogSettingsObject -Category "AuditEvent" -Enabled $true


#NSG
            # Create log settings objects for each category
$securityLogSettings = New-AzDiagnosticSettingLogSettingsObject -Category "NetworkSecurityGroupEvent" -Enabled $true
$ruleCounterLogSettings = New-AzDiagnosticSettingLogSettingsObject -Category "NetworkSecurityGroupRuleCounter" -Enabled $true


$logSettingsNSG = @(
    $securityLogSettings,
    $ruleCounterLogSettings
)

#AzureSQL

 # Create log settings objects for each category
 $devOpsOperationsAudit = New-AzDiagnosticSettingLogSettingsObject -Category "DevOpsOperationsAudit" -Enabled $true
 $sqlSecurityAuditEvents = New-AzDiagnosticSettingLogSettingsObject -Category "SQLSecurityAuditEvents" -Enabled $true

$logSettingsAzureSQL = @(
    $devOpsOperationsAudit,
    $sqlSecurityAuditEvents
                )      
                        
#AzureFirewall

            # Create log settings objects for each category
            $AzureFirewallApplicationRule = New-AzDiagnosticSettingLogSettingsObject -Category "AzureFirewallApplicationRule" -Enabled $true
            $firewallNetworkRuleLogs = New-AzDiagnosticSettingLogSettingsObject -Category "AzureFirewallNetworkRule" -Enabled $true
            $firewallDnsProxyLogs = New-AzDiagnosticSettingLogSettingsObject -Category "AzureFirewallDnsProxy" -Enabled $true
            $AZFWNetworkRule = New-AzDiagnosticSettingLogSettingsObject -Category "AZFWNetworkRule" -Enabled $true
            $AZFWApplicationRule = New-AzDiagnosticSettingLogSettingsObject -Category "AZFWApplicationRule" -Enabled $true
            $fAZFWNatRule = New-AzDiagnosticSettingLogSettingsObject -Category "AZFWNatRule" -Enabled $true
            $AZFWThreatIntel = New-AzDiagnosticSettingLogSettingsObject -Category "AZFWThreatIntel" -Enabled $true
            $AZFWIdpsSignature = New-AzDiagnosticSettingLogSettingsObject -Category "AZFWIdpsSignature" -Enabled $true
            $AZFWDnsQuery = New-AzDiagnosticSettingLogSettingsObject -Category "AZFWDnsQuery" -Enabled $true
            $AZFWFqdnResolveFailure = New-AzDiagnosticSettingLogSettingsObject -Category "AZFWFqdnResolveFailure" -Enabled $true
            $fAZFWFatFlow = New-AzDiagnosticSettingLogSettingsObject -Category "AZFWFatFlow" -Enabled $true
            $AZFWFlowTrace = New-AzDiagnosticSettingLogSettingsObject -Category "AZFWFlowTrace" -Enabled $true
            $AZFWApplicationRuleAggregation = New-AzDiagnosticSettingLogSettingsObject -Category "AZFWApplicationRuleAggregation" -Enabled $true
            $AZFWNetworkRuleAggregation = New-AzDiagnosticSettingLogSettingsObject -Category "AZFWNetworkRuleAggregation" -Enabled $true
            $AAZFWNatRuleAggregation = New-AzDiagnosticSettingLogSettingsObject -Category "AZFWNatRuleAggregation" -Enabled $true

            $logSettingsAzurerFirewall = @(
                $AzureFirewallApplicationRule, $firewallNetworkRuleLogs, $firewallDnsProxyLogs, $AZFWNetworkRule, $AZFWApplicationRule, $fAZFWNatRule, $AZFWThreatIntel, $AZFWIdpsSignature, $AZFWDnsQuery,
                $AZFWFqdnResolveFailure,$fAZFWFatFlow, $AZFWFlowTrace, $AZFWApplicationRuleAggregation, $AZFWNetworkRuleAggregation, $AAZFWNatRuleAggregation
            )
#PublicIPDDOS

# Create log settings objects for each category
$ddosProtectionLogs = New-AzDiagnosticSettingLogSettingsObject -Category "DDoSProtectionNotifications" -Enabled $true
$DDoSMitigationFlowLogs = New-AzDiagnosticSettingLogSettingsObject -Category "DDoSMitigationFlowLogs" -Enabled $true
$DDoSMitigationReports = New-AzDiagnosticSettingLogSettingsObject -Category "DDoSMitigationReports" -Enabled $true

$logSettingsPublicIPDDOS = @($ddosProtectionLogs, $DDoSMitigationFlowLogs, $DDoSMitigationReports )


#WAF_AppGateway
            # Create log settings objects for each category
            $ApplicationGatewayAccessLog = New-AzDiagnosticSettingLogSettingsObject -Category "ApplicationGatewayAccessLog" -Enabled $true
            $ApplicationGatewayPerformanceLog = New-AzDiagnosticSettingLogSettingsObject -Category "ApplicationGatewayPerformanceLog" -Enabled $true
            $ApplicationGatewayFirewallLog = New-AzDiagnosticSettingLogSettingsObject -Category "ApplicationGatewayFirewallLog" -Enabled $true

            $logSettingsWAF_AppGateway = @($ApplicationGatewayAccessLog, $ApplicationGatewayPerformanceLog, $ApplicationGatewayFirewallLog )

#WAF_FrontDoor

            # Create log settings objects for each category
            $FrontDoorAccessLog = New-AzDiagnosticSettingLogSettingsObject -Category "FrontDoorAccessLog" -Enabled $true
            $FrontDoorWebApplicationFirewallLog = New-AzDiagnosticSettingLogSettingsObject -Category "FrontDoorWebApplicationFirewallLog" -Enabled $true


            $logSettingsWAF_FrontDoor = @($FrontDoorAccessLog, $FrontDoorWebApplicationFirewallLog )

#WAF_PolicyDiagnostics

# Create log settings objects for each category
$WebApplicationFirewallLog = New-AzDiagnosticSettingLogSettingsObject -Category "WebApplicationFirewallLog" -Enabled $true


#AKS

 # Create log settings objects for each category
 $kubeApiServerLogSettings = New-AzDiagnosticSettingLogSettingsObject -Category "kube-apiserver" -Enabled $true
 $kubeAuditLogSettings = New-AzDiagnosticSettingLogSettingsObject -Category "kube-audit" -Enabled $true
 $kubeAuditAdminLogSettings = New-AzDiagnosticSettingLogSettingsObject -Category "kube-audit-admin" -Enabled $true
 $kubeControllerManagerLogSettings = New-AzDiagnosticSettingLogSettingsObject -Category "kube-controller-manager" -Enabled $true
 $kubeSchedulerLogSettings = New-AzDiagnosticSettingLogSettingsObject -Category "kube-scheduler" -Enabled $true
 $clusterAutoscalerLogSettings = New-AzDiagnosticSettingLogSettingsObject -Category "cluster-autoscaler" -Enabled $true
 $cloudControllerManagerLogSettings = New-AzDiagnosticSettingLogSettingsObject -Category "cloud-controller-manager" -Enabled $true
 $guardLogSettings = New-AzDiagnosticSettingLogSettingsObject -Category "guard" -Enabled $true
 $csiAzureDiskControllerLogSettings = New-AzDiagnosticSettingLogSettingsObject -Category "csi-azuredisk-controller" -Enabled $true
 $csiAzureFileControllerLogSettings = New-AzDiagnosticSettingLogSettingsObject -Category "csi-azurefile-controller" -Enabled $true
 $csiSnapshotControllerLogSettings = New-AzDiagnosticSettingLogSettingsObject -Category "csi-snapshot-controller" -Enabled $true

 $logSettingsAKS = @($kubeApiServerLogSettings, $kubeAuditLogSettings, $kubeAuditAdminLogSettings, $kubeControllerManagerLogSettings, $kubeSchedulerLogSettings, 
 $clusterAutoscalerLogSettings, $cloudControllerManagerLogSettings, $guardLogSettings, $csiAzureDiskControllerLogSettings, $csiAzureFileControllerLogSettings, $csiSnapshotControllerLogSettings )

 #StorageAccount

 $StorageAccountmetricSettings = New-AzDiagnosticSettingMetricSettingsObject -Category "AllMetrics" -Enabled $true


 


         $metricSettings = New-AzDiagnosticSettingMetricSettingsObject -Category "AllMetrics" -Enabled $true

         # Define multiple log categories to enable
 $StorageAccountlogCategories = @("StorageRead", "StorageWrite", "StorageDelete")



