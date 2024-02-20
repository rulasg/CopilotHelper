
function CopilotHelperTest_ExportCopilotUsageOrg_Totals{

    Export-CopilotUsageOrgTotals -Owner someOrgName -OutputFile totals.csv

    Assert-ItemExist -Path totals.csv

    $imported = Import-Csv -Path totals.csv

    Assert-Count -Expected $dataResultsTotals -Presented $imported
}

function CopilotHelperTest_ExportCopilotUsageOrg_Breakdown{

    Reset-InvokeCommandMock
    $owner = 'someOrgName'

    MockCall -Command "gh api orgs/$owner/copilot/usage" -filename $OrgTestDataFile

    Export-CopilotUsageOrgBreakdown -Owner $owner -OutputFile breakdown.csv

    Assert-ItemExist -Path breakdown.csv

    $imported = Import-Csv -Path breakdown.csv

    Assert-Count -Expected $dataResultsBreakdownOrg -Presented $imported

    $languages = $imported | Select-Object -Property language -Unique

    Assert-Count -Expected $dataResultLanguages -Presented $languages

}

function CopilotHelperTest_ExportCopilotUsageEnterprise_Breakdown{

    Reset-InvokeCommandMock
    $owner = 'someEnterpriseName'

    MockCall -Command "gh api enterprises/$owner/copilot/usage" -filename $EnterpriseTestDataFile

    Export-CopilotUsageEnterpriseBreakdown -Enterprise $owner -OutputFile breakdown.csv

    Assert-ItemExist -Path breakdown.csv

    $imported = Import-Csv -Path breakdown.csv

    Assert-Count -Expected $dataResultsBreakdownEnterprise -Presented $imported

    $languages = $imported | Select-Object -Property language -Unique

    Assert-Count -Expected $dataResultLanguages -Presented $languages
}