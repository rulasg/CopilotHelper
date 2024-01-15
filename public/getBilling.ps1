Set-InvokeCommandAlias -Alias CopilotBilling -Command 'gh api /orgs/{owner}/copilot/billing'

<#
.SYNOPSIS
    Get the billing information for an organization.
#>
function Get-CopilotBilling{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)][string]$Owner
    )

    process{

        $environment = Get-EnvironmentOwner -Owner $Owner

        $param = @{'owner' = $environment}

        $result = Invoke-MyCommandJson -Command CopilotBilling -Param $param

        if($null -eq $result){
            "Error calling CopilotBilling with [$owner]" | Write-Verbose
            $ret = $null
            return
        } elseif ($result.message -eq "Not Found"){
            "Error calling CopilotBilling with [$owner] - $($result.message)" | Write-Verbose
            $ret = $null
            return
        } else {
            $ret = $result
        }

        $retObj = [PSCustomObject]@{
            Org = $environment
            seat_management_setting = $ret.seat_management_setting
            public_code_suggestions = $ret.public_code_suggestions
            copilot_chat = $ret.copilot_chat

            total                 = $ret.seat_breakdown.total
            added_this_cycle     = $ret.seat_breakdown.added_this_cycle
            pending_invitation   = $ret.seat_breakdown.pending_invitation
            pending_cancellation = $ret.seat_breakdown.pending_cancellation
            active_this_cycle     = $ret.seat_breakdown.active_this_cycle
            inactive_this_cycle   = $ret.seat_breakdown.inactive_this_cycle
        }

        $retObj | Write-Output
    }

} Export-ModuleMember -Function Get-CopilotBilling