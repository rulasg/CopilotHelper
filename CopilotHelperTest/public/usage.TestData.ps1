
# TestData

$OrgTestDataFile = $PSScriptRoot | Join-Path -ChildPath 'testData' -AdditionalChildPath 'CopilotUsageOrg.json'
$EnterpriseTestDataFile = $PSScriptRoot | Join-Path -ChildPath 'testData' -AdditionalChildPath 'CopilotUsageEnterprise.json'

$dataResultsTotals = 27
$dataResultsBreakdownOrg = 237
$dataResultsBreakdownEnterprise = 474
$dataResultLanguages = 35

Set-InvokeCommandAlias -Alias 'gh api orgs/someOrgName/copilot/usage'                -Command "Get-Content -Path $(($OrgTestDataFile | Get-Item).FullName)"
Set-InvokeCommandAlias -Alias 'gh api enterprises/someEnterpriseName/copilot/usage'  -Command "Get-Content -Path $(($EnterpriseTestDataFile | Get-Item).FullName)"
