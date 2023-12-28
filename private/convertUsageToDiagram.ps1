<#
.SYNOPSIS
    Convert the totals of Copilot usage data to Diagram.
#>
function Convert-UsageToDiagramTotals{
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
        # $cals_total_active_users = Get-Calcs $entries.total_active_users
        $cals_total_suggestions_count = Get-Calcs $entries.total_suggestions_count
        $cals_total_acceptances_count = Get-Calcs $entries.total_acceptances_count
        $cals_total_lines_suggested = Get-Calcs $entries.total_lines_suggested
        $cals_total_lines_accepted = Get-Calcs $entries.total_lines_accepted
        
        $markdown =@()
        
        # Accepted Count
        $title = "Acceptance Count"
        $param = @{
            Title = $title
            Name = "Accepted"
            Total = $cals_total_suggestions_count.total
            Positive = $cals_total_acceptances_count.total
        }
        $markdown = ConvertTo-MermaidPieTotalAndTrue @param | Convert-MermaidToMarkdown

        # Accepted Lines
        $title = "Acceptance Lines"
        $param = @{
            Title = $title
            Name = "Accepted"
            Total = $cals_total_lines_suggested.total
            Positive = $cals_total_lines_accepted.total
        }
        $markdown += ConvertTo-MermaidPieTotalAndTrue @param | Convert-MermaidToMarkdown

        return $markdown
    }
}

<#
.SYNOPSIS
    Covnerts the breakdown of Copilot usage data to Markdown Table.
#>
function Convert-UsageToDiagramBreakdown{
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