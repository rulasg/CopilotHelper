function CopilotHelperTest_GetBilling {

    Reset-InvokeCommandMock

    $owner = 'mockorg'

    MockCall -Command "gh api /orgs/$owner/copilot/billing" -filename 'CopilotBillingOrg.json'

    $result = Get-CopilotBilling -Owner $owner

    Assert-Count -Expected 1 -Presented $result

    Assert-AreEqual -Expected $owner          -Presented $result.Org

    Assert-AreEqual -Expected "assign_all"    -Presented $result.seat_management_setting
    Assert-AreEqual -Expected "allow"         -Presented $result.public_code_suggestions
    Assert-AreEqual -Expected "enabled"       -Presented $result.copilot_chat
    Assert-AreEqual -Expected "43"            -Presented $result.total
    Assert-AreEqual -Expected "0"             -Presented $result.added_this_cycle
    Assert-AreEqual -Expected "0"             -Presented $result.pending_invitation
    Assert-AreEqual -Expected "0"             -Presented $result.pending_cancellation
    Assert-AreEqual -Expected "23"            -Presented $result.active_this_cycle
    Assert-AreEqual -Expected "20"            -Presented $result.inactive_this_cycle
}

function CopilotHelperTest_GetBilling_NotFound{

    Reset-InvokeCommandMock

    $owner = 'mockorg'

    MockCall -Command "gh api /orgs/$owner/copilot/billing" -filename 'CopilotBillingOrgWrongOrg.json'

    $result = Get-CopilotBilling -Owner $owner

    Assert-IsNull -Object $result
}

function CopilotHelperTest_GetBilling_Multiple_Orgs{

    Reset-InvokeCommandMock

    $owner1 = 'mockorg1'
    $owner2 = 'mockorg2'

    MockCall -Command "gh api /orgs/$owner1/copilot/billing" -filename 'CopilotBillingOrg.json'
    MockCall -Command "gh api /orgs/$owner2/copilot/billing" -filename 'CopilotBillingOrg.json'

    $result = $owner1,$owner2 | Get-CopilotBilling

    Assert-Count -Expected 2 -Presented $result.Org
    Assert-Contains -Expected $owner1 -Presented $result.Org
    Assert-Contains -Expected $owner2 -Presented $result.Org
}
