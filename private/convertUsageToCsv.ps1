<#
.SYNOPSIS
    Covnerts the totals of Copilot usage data to CSV.
.EXAMPLE
    Get-CopilotUsageOrg -Owner 'github' | Convert-UsageToCsvTotals
#>
function Convert-UsageToCsvTotals{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline)][Object]$Entry
    )

    begin {
        $entries = @()
    }

    process {

        $entries += $Entry | Convert-UsageToTotals
    }

    end {
        $csv = $entries | ConvertTo-Csv -NoTypeInformation
        return $csv
    }
}

<#
.SYNOPSIS
    Covnerts the breakdown of Copilot usage data to CSV.
.EXAMPLE
    Get-CopilotUsageOrg -Owner 'github' | Convert-UsageToCsvBreakdown
#>
function Convert-UsageToCsvBreakdown{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline)][PSCustomObject]$Entry
    )

    begin {
        $entries = @()
    }

    process {
        $entries += $Entry | Convert-UsageToBreakdown
    }

    end {
        $csv = $entries | ConvertTo-Csv -NoTypeInformation
        return $csv
    }
}