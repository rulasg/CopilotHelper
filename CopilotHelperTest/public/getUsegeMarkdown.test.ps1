
function CopilotHelperTest_GetCopilotUsageMarkdownOrg_Totals{

    Reset-InvokeCommandMock

    $owner = 'someOrgName'

    MockCall -Command "gh api orgs/$owner/copilot/usage" -filename $OrgTestDataFile

    $result = Get-CopilotUsageOrgMarkdownTotals -Owner $owner

    Assert-Count -Expected $($dataResultsTotals + 2) -Presented $result
}

function CopilotHelperTest_GetCopilotUsageMarkdownOrg_Breakdown{

    Reset-InvokeCommandMock

    $owner = 'someOrgName'

    MockCall -Command "gh api orgs/$owner/copilot/usage" -filename $OrgTestDataFile

    $result = Get-CopilotUsageOrgMarkdownBreakdown -Owner $owner

    Assert-Count -Expected $($dataResultsBreakdownOrg + 2) -Presented $result
}

function CopilotHelperTest_GetCopilotUsageMarkdownEnterprise_Breakdown{

    Reset-InvokeCommandMock
    $owner = 'someEnterpriseName'

    MockCall -Command "gh api enterprises/$owner/copilot/usage" -filename $EnterpriseTestDataFile

    $result = Get-CopilotUsageEnterpriseMarkdownBreakdown -Enterprise $owner

    Assert-Count -Expected $($dataResultsBreakdownEnterprise + 2) -Presented $result
}