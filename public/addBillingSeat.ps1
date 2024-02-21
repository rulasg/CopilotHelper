# REF: https://docs.github.com/en/rest/copilot/copilot-business?apiVersion=2022-11-28#add-users-to-the-copilot-business-subscription-for-an-organization

Set-MyInvokeCommandAlias -Alias RemoveBillingUser -Command 'gh api --method DELETE /orgs/{owner}/copilot/billing/selected_users -f "selected_usernames[]={user}"'
Set-MyInvokeCommandAlias -Alias AddBillingUser -Command 'gh api --method POST /orgs/{owner}/copilot/billing/selected_users -f "selected_usernames[]={user}"'


<#
.SYNOPSIS
    Remove a user from the billing seats for an organization.
.EXAMPLE
    Remove-CopilotBillingUser -Owner 'github' -User 'octocat'
    "user1","user2" | Remove-CopilotBillingUser -Owner 'github'
    Get-CopilotBillingSeats -Owner 'github' | Show-SeatsActiveThisCycle | Remove-CopilotBillingUser
#>
function Remove-CopilotBillingUser{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(ValueFromPipelineByPropertyName)][string]$Owner,
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)][Alias("Assignee")][string]$User
    )

    begin{
        $seats_cancelled = 0
    }

    process {
        "Removing user [$user] from billing seats for [$owner]" | Write-Verbose

        $param = @{'owner' = $owner; 'user' = $User}

        if ($PSCmdlet.ShouldProcess("user [$user] for [$owner]", "RemoveBillingUser")) {
            $result = Invoke-MyCommandJson -Command RemoveBillingUser -Param $param
        } else{
            $result = [PSCustomObject]@{
                seats_cancelled = 1
            }
        }

        if($null -eq $result){
            "Error calling RemoveBillingUser with [$owner] and [$user]" | Write-Error
            $ret = $null
            return
        } elseif ($result.message -eq "Not Found"){
            "Error calling RemoveBillingUser with [$owner] and [$user] - $($result.message)" | Write-Error
            $ret = $null
            return
        } elseif ($null -ne $result.message){
            "Error calling RemoveBillingUser with [$owner] and [$user] - $($result.message)" | Write-Error
            $ret = $null
            return
        } elseif ($null -eq $result.message){
            $ret = $result
        } else {
            throw "we should never reach this point"
        }

        $seats_cancelled += $ret.seats_cancelled
    }
    end{
        $finalRet = [PSCustomObject]@{
            seats_cancelled = $seats_cancelled
        }
        return $finalRet
    }
} Export-ModuleMember -Function Remove-CopilotBillingUser

<#
.SYNOPSIS
    Add a user to the billing seats for an organization.
.EXAMPLE
    Add-CopilotBillingUser -Owner 'github' -User 'octocat'
    "user1","user2" | Add-CopilotBillingUser -Owner 'github'
    Get-CopilotBillingSeats -Owner 'github' | Show-SeatsActiveThisCycle | Add-CopilotBillingUser
#>
function Add-CopilotBillingUser{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(ValueFromPipelineByPropertyName)][string]$Owner,
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)][Alias("Assignee")][string]$User
    )

    begin{
        $seats_created = 0
    }

    process {
        "Removing user [$user] from billing seats for [$owner]" | Write-Verbose

        $param = @{'owner' = $owner; 'user' = $User}

        if ($PSCmdlet.ShouldProcess("user [$user] for [$owner]", "AddBillingUser")) {
            $result = Invoke-MyCommandJson -Command AddBillingUser -Param $param
        } else{
            $result = [PSCustomObject]@{
                seats_created = 1
            }
        }

        if($null -eq $result){
            "Error calling AddBillingUser with [$owner] and [$user]" | Write-Error
            $ret = $null
            return
        } elseif ($result.message -eq "Not Found"){
            "Error calling AddBillingUser with [$owner] and [$user] - $($result.message)" | Write-Error
            $ret = $null
            return
        } elseif ($null -ne $result.message){
            "Error calling AddBillingUser with [$owner] and [$user] - $($result.message)" | Write-Error
            $ret = $null
            return
        } elseif ($null -eq $result.message){
            $ret = $result
        } else {
            throw "we should never reach this point"
        }

        $seats_created += $ret.seats_created
    }

    end{
        $finalRet = [PSCustomObject]@{
            seats_created = $seats_created
        }
        return $finalRet
    }
} Export-ModuleMember -Function Add-CopilotBillingUser