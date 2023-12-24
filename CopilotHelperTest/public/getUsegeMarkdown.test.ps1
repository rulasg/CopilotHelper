
function CopilotHelperTest_GetCopilotUsageMarkdownOrg_Totals{

    $result = Get-CopilotUsageOrgMarkdownTotals -Owner someOrgName

    Assert-Count -Expected $($dataResultsTotals + 2) -Presented $result
}

function CopilotHelperTest_GetCopilotUsageMarkdownOrg_Breakdown{

    $result = Get-CopilotUsageOrgMarkdownBreakdown -Owner someOrgName

    Assert-Count -Expected $($dataResultsBreakdownOrg + 2) -Presented $result
}

function CopilotHelperTest_GetCopilotUsageMarkdownEnterprise_Breakdown{

    $result = Get-CopilotUsageEnterpriseMarkdownBreakdown -Enterprise someEnterpriseName

    Assert-Count -Expected $($dataResultsBreakdownEnterprise + 2) -Presented $result
}