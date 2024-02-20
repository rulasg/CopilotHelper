function CopilotHelperTest_GetCopilotBillingSeat_Success{

    Reset-InvokeCommandMock

    $owner = "solidifydemo"

    MockCall -command "gh api /orgs/$owner/copilot/billing/seat" -filename 'CopilotbillingOrgSeats.json'

    $result = Get-CopilotBillingSeats -Owner $owner

    Assert-Count -Expected 45 -Presented $result
    Assert-Contains -Expected "rulasg" -Presented $result.Assignee

}

function CopilotHelperTest_GetCopilotBillingSeat_Show_InactiveThisCycle{

    Reset-InvokeCommandMock

    $owner = "solidifydemo"

    MockCall -command "gh api /orgs/$owner/copilot/billing/seat" -filename 'CopilotbillingOrgSeats.json'

    $seats = Get-CopilotBillingSeats -Owner $owner

    $result = $seats | Show-InactiveThisCycle

    Assert-Count -Expected 19 -Presented $result

}

function CopilotHelperTest_GetCopilotBillingSeat_Show_AddedThisCycle{

    Reset-InvokeCommandMock

    $owner = "solidifydemo"

    MockCall -command "gh api /orgs/$owner/copilot/billing/seat" -filename 'CopilotbillingOrgSeats.json'

    $seats = Get-CopilotBillingSeats -Owner $owner

    $result = $seats | Show-AddedThisCycle

    Assert-Count -Expected 3 -Presented $result

}