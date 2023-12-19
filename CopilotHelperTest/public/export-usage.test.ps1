
# TestData

$OrgTestDataFile = $PSScriptRoot | Join-Path -ChildPath 'testData' -AdditionalChildPath 'CopilotUsageOrg.json'
$EnterpriseTestDataFile = $PSScriptRoot | Join-Path -ChildPath 'testData' -AdditionalChildPath 'CopilotUsageEnterprise.json'

$dataResultsTotals = 27
$dataResultsBreakdownOrg = 237
$dataResultsBreakdownEnterprise = 474
$dataResultLanguages = 35

# Mock
Set-InvokeCommandAlias -Alias CopilotUsageOrg -Command "Get-Content -Path $(($OrgTestDataFile | Get-Item).FullName)"
Set-InvokeCommandAlias -Alias CopilotUsageEnterprise -Command "Get-Content -Path $(($EnterpriseTestDataFile | Get-Item).FullName)"

# Tests

function CopilotHelperTest_CopilotUsageOrg_Get{

    $result = Get-CopilotUsageOrg -Owner someOrgName

    Assert-Count -Expected $dataResultsTotals -Presented $result
    Assert-Count -Expected $dataResultsBreakdownOrg -Presented $result.breakdown
}

function CopilotHelperTest_ExportCopilotUsageOrg_Totals{

    Export-CopilotUsageOrgTotals -Owner someOrgName -OutputFile totals.csv

    Assert-ItemExist -Path totals.csv

    $imported = Import-Csv -Path totals.csv

    Assert-Count -Expected $dataResultsTotals -Presented $imported
}

function CopilotHelperTest_ExportCopilotUsageOrg_Breakdown{

    Export-CopilotUsageOrgBreakdown -Owner someOrgName -OutputFile breakdown.csv

    Assert-ItemExist -Path breakdown.csv

    $imported = Import-Csv -Path breakdown.csv

    Assert-Count -Expected $dataResultsBreakdownOrg -Presented $imported

    $languages = $imported | Select-Object -Property language -Unique

    Assert-Count -Expected $dataResultLanguages -Presented $languages

}

function CopilotHelperTest_CopilotUsagEnterprise_Get{

    $result = Get-CopilotUsageEnterprise -Enterprise 'someEnterpriseName'

    Assert-Count -Expected $dataResultsTotals -Presented $result
    Assert-Count -Expected $dataResultsBreakdownEnterprise -Presented $result.breakdown
}

function CopilotHelperTest_ExportCopilotUsageEnterprise_Breakdown{

    Export-CopilotUsageEnterpriseBreakdown -Enterprise someEnterpriseName -OutputFile breakdown.csv

    Assert-ItemExist -Path breakdown.csv

    $imported = Import-Csv -Path breakdown.csv

    Assert-Count -Expected $dataResultsBreakdownEnterprise -Presented $imported

    $languages = $imported | Select-Object -Property language -Unique

    Assert-Count -Expected $dataResultLanguages -Presented $languages
}