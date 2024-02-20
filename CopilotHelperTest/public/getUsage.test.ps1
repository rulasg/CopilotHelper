
function CopilotHelperTest_CopilotUsageOrg_Get{

    Reset-InvokeCommandMock
    $owner = 'someOrgName'

    MockCall -Command "gh api orgs/$owner/copilot/usage" -filename $OrgTestDataFile

    $result = Get-CopilotUsageOrg -Owner $owner

    Assert-Count -Expected $dataResultsTotals -Presented $result
    Assert-Count -Expected $dataResultsBreakdownOrg -Presented $result.breakdown
}

function CopilotHelperTest_CopilotUsagEnterprise_Get{

    Reset-InvokeCommandMock
    $owner = 'someEnterpriseName'

    MockCall -Command "gh api enterprises/$owner/copilot/usage" -filename $EnterpriseTestDataFile
    
    $result = Get-CopilotUsageEnterprise -Enterprise $owner

    Assert-Count -Expected $dataResultsTotals -Presented $result
    Assert-Count -Expected $dataResultsBreakdownEnterprise -Presented $result.breakdown
}
