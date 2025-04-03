# List of child script paths
$childScripts = @(
   "Child_AzureActivity.ps1",
   "Child_KeyvVault.ps1",
   "Child_NSG.ps1",
   "Child_AzureSQL.ps1",
   "Child_AzureFirewall.ps1",
   "Child_PublicIPDDOS.ps1",
   "Child_WAF_AppGateway.ps1",
   #"Child_WAF_FrontDoor.ps1", - I have not tested this scripts as I dont have these resources in my LAB
   #"Child_WAF_PolicyDiagnostics.ps1",  - I have not tested this scripts as I dont have these resources in my LAB
   "Child_AKS.ps1",
   "Child_StorageAccount.ps1"
)

# Loop through each child script and execute it
foreach ($script in $childScripts) {
    Write-Host "Executing $script"
    Invoke-Expression -Command (Get-Content -Path $script -Raw)
}