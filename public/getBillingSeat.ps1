Set-MyInvokeCommandAlias -Alias CopilotBillingSeat -Command 'gh api /orgs/{owner}/copilot/billing/seat'

<#
.SYNOPSIS
    Get the billing seats information for an organization.
#>
function Get-CopilotBillingSeats{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)][string]$Owner
    )

    process {
        $environment = Get-EnvironmentOwner -Owner $Owner

        $param = @{'owner' = $environment}

        $result = Invoke-MyCommandJson -Command CopilotBillingSeat -Param $param

        if($null -eq $result){
            "Error calling CopilotBillingSeat with [$owner]" | Write-Verbose
            $ret = $null
            return
        } elseif ($result.message -eq "Not Found"){
            "Error calling CopilotBillingSeat with [$owner] - $($result.message)" | Write-Verbose
            $ret = $null
            return
        } else {
            $ret = $result
        }

        $retObj =@()

        foreach($seat in $ret.seats){
            $retObj += [PSCustomObject]@{
                Assignee = $seat.assignee.login
                Created_at = $seat.created_at
                Last_activity_at = $seat.last_activity_at
                Last_activity_editor = $seat.last_activity_editor
                Pending_cancellation_date = $seat.pending_cancellation_date
                Updated_at = $seat.updated_at
            }
        }

        return $retObj
    
    }
} Export-ModuleMember -Function Get-CopilotBillingSeats

<#
.SYNOPSIS
    Show the inactive seats for the current cycle.
#>
function Show-InactiveThisCycle {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline)][object]$Seat
    )

    begin{
        $startCycleDateTime = Get-StartCycleDateTime
    }

    process {

        "$($seat.Assignee) last activity was $($seat.Last_activity_at)" | Write-Verbose

        # No activity recorded
        if($null -eq $seat.Last_activity_at){
            Write-Output $seat
            return
        }

        # Last activity last day last month
        if ($seat.last_activity_at -lt $startCycleDateTime) {
            Write-Output $seat
        }
    }
} Export-ModuleMember -Function Show-InactiveThisCycle

<#
.SYNOPSIS
    Show the added seats for the current cycle.
#>
function Show-AddedThisCycle {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline)][object]$Seat
    )

    begin{
        $startCycleDateTime = Get-StartCycleDateTime
    }

    process {
        $date = $seat.updated_at

        "$($seat.Assignee) date $date" | Write-Verbose

        # Last activity last day last month
        if ($date -gt $startCycleDateTime -and $date -ne $startCycleDateTime) {
            Write-Output $seat
        }
    }
} Export-ModuleMember -Function Show-AddedThisCycle

<#
.SYNOPSIS
    Show the active seats for the current cycle.
#>
function Show-ActiveThisCycle {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline)][object]$Seat
    )

    begin{
        $today = Get-Date
        $startCycleDateTime = $today.Date.AddDays(- $today.Day)
    }

    process {

        "$($seat.Assignee) last activity was $($seat.Last_activity_at)" | Write-Verbose

        # No activity recorded
        if($null -eq $seat.Last_activity_at){
            Write-Output $seat
            return
        }

        # Last activity last day last month
        if ($seat.last_activity_at -lt $startCycleDateTime) {
            Write-Output $seat
        }
    }
} Export-ModuleMember -Function Show-InactiveThisCycle

function Get-StartCycleDateTime{
    # Cycle starts at 1am last day of the previouse month.
    # Check Update_at date of old seats
    $today = Get-Date
    $ret = $today.Date.AddDays(- $today.Day).AddHours(1)

    return $ret
}

