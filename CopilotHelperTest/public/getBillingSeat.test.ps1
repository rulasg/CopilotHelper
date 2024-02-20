function CopilotHelperTest_GetCopilotBillingSeat_Success{

    Reset-InvokeCommandMock

    $owner = "solidifydemo"

    MockCall -command "gh api /orgs/$owner/copilot/billing/seats" -filename 'CopilotbillingOrgSeats.json'

    $result = Get-CopilotBillingSeats -Owner $owner

    Assert-Count -Expected 45 -Presented $result
    Assert-Contains -Expected "rulasg" -Presented $result.Assignee

}

function CopilotHelperTest_GetCopilotBillingSeat_Show_InactiveThisCycle{

    Reset-InvokeCommandMock

    $owner = "solidifydemo"

    MockCall -command "gh api /orgs/$owner/copilot/billing/seats" -filename 'CopilotbillingOrgSeats.json'

    $seats = Get-CopilotBillingSeats -Owner $owner

    $result = $seats | Show-SeatsInactiveThisCycle

    Assert-Count -Expected 19 -Presented $result

}

function CopilotHelperTest_GetCopilotBillingSeat_Show_ActiveThisCycle{

    Reset-InvokeCommandMock

    $owner = "solidifydemo"

    MockCall -command "gh api /orgs/$owner/copilot/billing/seats" -filename 'CopilotbillingOrgSeats.json'

    $seats = Get-CopilotBillingSeats -Owner $owner

    $result = $seats | Show-SeatsActiveThisCycle

    Assert-Count -Expected 26 -Presented $result

}

function CopilotHelperTest_GetCopilotBillingSeat_Show_AddedThisCycle{

    Reset-InvokeCommandMock

    $owner = "solidifydemo"

    MockCall -command "gh api /orgs/$owner/copilot/billing/seats" -filename 'CopilotbillingOrgSeats.json'

    $seats = Get-CopilotBillingSeats -Owner $owner

    $result = $seats | Show-SeatsAddedThisCycle

    Assert-Count -Expected 3 -Presented $result

}