function CopilotHelperTest_GetBilling {

    $owner = 'mockorg'

    $GetBilling = $PSScriptRoot | Join-Path -ChildPath 'testData' -AdditionalChildPath 'CopilotBillingOrg.json'
    Set-InvokeCommandMock -Alias "gh api /orgs/$owner/copilot/billing" -Command "Get-Content -Path $(($GetBilling | Get-Item).FullName)"

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

    $owner = 'mockorg'

    $GetBilling = $PSScriptRoot | Join-Path -ChildPath 'testData' -AdditionalChildPath 'CopilotBillingOrgWrongOrg.json'
    Set-InvokeCommandMock -Alias "gh api /orgs/$owner/copilot/billing" -Command "Get-Content -Path $(($GetBilling | Get-Item).FullName)"

    $result = Get-CopilotBilling -Owner $owner

    Assert-IsNull -Object $result
}

function CopilotHelperTest_GetBilling_Multiple_Orgs{

    $owner1 = 'mockorg1'
    $owner2 = 'mockorg2'

    $mockResult = $PSScriptRoot | Join-Path -ChildPath 'testData' -AdditionalChildPath 'CopilotBillingOrg.json'
    
    Set-InvokeCommandMock -Alias "gh api /orgs/$owner1/copilot/billing" -Command "Get-Content -Path $(($mockResult | Get-Item).FullName)"
    Set-InvokeCommandMock -Alias "gh api /orgs/$owner2/copilot/billing" -Command "Get-Content -Path $(($mockResult | Get-Item).FullName)"

    $result = $owner1,$owner2 | Get-CopilotBilling

    Assert-Count -Expected 2 -Presented $result.Org
    Assert-Contains -Expected $owner1 -Presented $result.Org
    Assert-Contains -Expected $owner2 -Presented $result.Org

}
