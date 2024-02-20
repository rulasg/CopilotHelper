
function CopilotHelperTest_RemoveBillingSeat{

    Reset-InvokeCommandMock

    $owner ='solidifydemo' ; $user= 'raulgeu'
    $errorMessage = "Error calling RemoveBillingUser with [$owner] and [$user] - Your organization has enabled Copilot access for all members. Enable access for selected members in order to manage seats via the API."

    MockCall -filename 'CopilotBillingUser_WrongSettings.json' -Command 'gh api --method DELETE /orgs/solidifydemo/copilot/billing/selected_users -f "selected_usernames[]=raulgeu"'

    $result = Remove-CopilotBillingUser -Owner $owner -User $user @ErrorParameters

    Assert-IsNull -Object $result

    Assert-Contains -Presented $errorvar.Exception.Message -Expected $errorMessage
}

function CopilotHelperTest_RemoveBillingSeat_WrongSettings{

    Reset-InvokeCommandMock

    $owner ='solidifydemo' ; $user= 'raulgeu'

    $errorMessage = "Error calling RemoveBillingUser with [$owner] and [$user] - Your organization has enabled Copilot access for all members. Enable access for selected members in order to manage seats via the API."


    MockCall -filename 'CopilotBillingUser_WrongSettings.json' -Command 'gh api --method DELETE /orgs/solidifydemo/copilot/billing/selected_users -f "selected_usernames[]=raulgeu"'

    $result = Remove-CopilotBillingUser -Owner $owner -User $user @ErrorParameters

    Assert-IsNull -Object $result

    Assert-Contains -Presented $errorvar.Exception.Message -Expected $errorMessage
}

function CopilotHelperTest_RemoveBillingSeat_SUCCESS{

    Reset-InvokeCommandMock

    $owner ='solidifydemo' ; $user= 'raulgeu'

    MockCallToString -OutString '{"seats_cancelled": 1}' -Command 'gh api --method DELETE /orgs/solidifydemo/copilot/billing/selected_users -f "selected_usernames[]=raulgeu"'

    $result = Remove-CopilotBillingUser -Owner $owner -User $user

    Assert-AreEqual -Expected 1 -Presented $result.seats_cancelled
}

function CopilotHelperTest_AddBillingSeat_WringSettings{

    Reset-InvokeCommandMock

    $owner ='solidifydemo' ; $user= 'raulgeu'
    $errorMessage = "Error calling AddBillingUser with [$owner] and [$user] - Your organization has enabled Copilot access for all members. Enable access for selected members in order to manage seats via the API."

    MockCall -filename 'CopilotBillingUser_WrongSettings.json' -Command 'gh api --method Post /orgs/solidifydemo/copilot/billing/selected_users -f "selected_usernames[]=raulgeu"'

    $result = Add-CopilotBillingUser -Owner $owner -User $user @ErrorParameters

    Assert-IsNull -Object $result

    Assert-Contains -Presented $errorvar.Exception.Message -Expected $errorMessage
}

function CopilotHelperTest_AddBillingSeat_SUCCESS{

    Reset-InvokeCommandMock

    $owner ='solidifydemo' ; $user= 'raulgeu'

    MockCallToString -OutString '{"seats_created":1}' -Command 'gh api --method Post /orgs/solidifydemo/copilot/billing/selected_users -f "selected_usernames[]=raulgeu"'

    $result = Add-CopilotBillingUser -Owner $owner -User $user

    Assert-AreEqual -Expected 1 -Presented $result.seats_created

}

