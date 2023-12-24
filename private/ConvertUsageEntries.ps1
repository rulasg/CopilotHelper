<#
.SYNOPSIS
    Covnerts the totals of Copilot usage data .
#>
function Convert-UsageToTotals{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline)][Object]$Entry
    )

    begin {
        $entries = @()
    }

    process {

        $entries += @{
            entry_type = "Total"
            day = $Entry.day
            # Data from API
            total_active_users = $Entry.total_active_users
            total_suggestions_count = $Entry.total_suggestions_count
            total_acceptances_count = $Entry.total_acceptances_count
            total_lines_suggested = $Entry.total_lines_suggested
            total_lines_accepted = $Entry.total_lines_accepted

            # Extra calculations
            total_ratio_count = Get-Ratio $Entry.total_acceptances_count  $Entry.total_suggestions_count
            total_ratio_lines = Get-Ratio $Entry.total_lines_accepted  $Entry.total_lines_suggested
        }
    }

    end {
        return $entries
    }
}

<#
.SYNOPSIS
    Covnerts the breakdown of Copilot usage data .
#>
function Convert-UsageToBreakdown{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline)][PSCustomObject]$Entry
    )

    begin {
        $entries = @()
    }

    process {
        $entries += $Entry.breakdown | ForEach-Object {
            @{
                entry_type = "Breakdown"
                day = $Entry.day
                language = $_.language
                editor = $_.editor
                active_users = $_.active_users
                suggestions_count = $_.suggestions_count
                acceptances_count = $_.acceptances_count
                lines_suggested = $_.lines_suggested
                lines_accepted = $_.lines_accepted

                # Extra calculations
                ratio_count = Get-Ratio $_.acceptances_count $_.suggestions_count
                ratio_lines = Get-Ratio $_.lines_accepted  $_.lines_suggested
            }
        }
    }

    end {
        return $entries
    }
}