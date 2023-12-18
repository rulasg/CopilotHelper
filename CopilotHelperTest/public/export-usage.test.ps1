
function CopilotHelperTest_ExportCopilotUsage_Totals{

    $result = Export-CopilotUsageTotals -Owner solidifydemo -OutputFile  totals.csv

    Assert-ItemExist -Path totals.csv

    $imported = Import-Csv -Path totals.csv

    Assert-NotImplemented

}

function CopilotHelperTest_ExportCopilotUsage_Breakdown{

    $result = Export-CopilotUsageBreakdown -Owner solidifydemo -OutputFile breakdown.csv

    Assert-ItemExist -Path breakdown.csv

    $imported = Import-Csv -Path breakdown.csv

    Assert-NotImplemented

}