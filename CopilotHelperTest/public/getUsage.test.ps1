
function CopilotHelperTest_CopilotUsageOrg_Get{

    $result = Get-CopilotUsageOrg -Owner someOrgName

    Assert-Count -Expected $dataResultsTotals -Presented $result
    Assert-Count -Expected $dataResultsBreakdownOrg -Presented $result.breakdown
}

function CopilotHelperTest_CopilotUsagEnterprise_Get{

    $result = Get-CopilotUsageEnterprise -Enterprise someEnterpriseName

    Assert-Count -Expected $dataResultsTotals -Presented $result
    Assert-Count -Expected $dataResultsBreakdownEnterprise -Presented $result.breakdown
}
