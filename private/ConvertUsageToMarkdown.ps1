<#
.SYNOPSIS
    Covnerts the totals of Copilot usage data to Markdown Table.
.EXAMPLE
    Get-CopilotUsageOrg -Owner 'github' | Convert-UsageToMarkdownTotals
#>
function Convert-UsageToMarkdownTotals{
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
        $markdown = $entries | ConvertTo-MarkdownTable
        return $markdown
    }
}

<#
.SYNOPSIS
    Covnerts the breakdown of Copilot usage data to Markdown Table.
.EXAMPLE
    Get-CopilotUsageOrg -Owner 'github' | Convert-UsageToMarkdownBreakdown
#>
function Convert-UsageToMarkdownBreakdown{
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
        $markdown = $entries | ConvertTo-MarkdownTable
        return $markdown
    }
}