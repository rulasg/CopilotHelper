
function CopilotHelperTest_ExportCopilotUsage_Totals{

    $testDataItem = $PSScriptRoot | Join-Path -ChildPath 'testData' -AdditionalChildPath 'CopilotUsageOrg.json' | Get-Item
    Set-InvokeCommandAlias -Alias CopilotUsage -Command "Get-Content -Path $($testDataItem.FullName)"

    Export-CopilotUsageTotals -Owner solidifydemo -OutputFile totals.csv

    Assert-ItemExist -Path totals.csv

    $imported = Import-Csv -Path totals.csv

    Assert-Count -Expected 27 -Presented $imported
}

function CopilotHelperTest_ExportCopilotUsage_Breakdown{

    $testDataItem = $PSScriptRoot | Join-Path -ChildPath 'testData' -AdditionalChildPath 'CopilotUsageOrg.json' | Get-Item
    Set-InvokeCommandAlias -Alias CopilotUsage -Command "Get-Content -Path $($testDataItem.FullName)"

    Export-CopilotUsageBreakdown -Owner solidifydemo -OutputFile breakdown.csv

    Assert-ItemExist -Path breakdown.csv

    $imported = Import-Csv -Path breakdown.csv

    Assert-Count -Expected 237 -Presented $imported

    $languages = $imported | Select-Object -Property language -Unique

    Assert-Count -Expected 35 -Presented $languages

}