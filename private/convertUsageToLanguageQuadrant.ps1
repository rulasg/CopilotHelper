<#
.SYNOPSIS
    Covnerts the breakdown of Copilot usage data to Quadrant Diagrams.
.EXAMPLE
    Get-CopilotUsageOrg -Owner 'github' | Convert-UsageToDiagramLanguageQuadrant
#>
function Convert-UsageToDiagramLanguageQuadrant{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline)][Object]$Entry
    )

    begin {
        $entries = @()
    }

    process {

        $entries += $Entry | Convert-UsageToBreakdown
    }

    end {
        $markdown =@()

        $calcsByLanguage = Get-CalcsByProperty2 language $entries

        # Language Quadrant

        $mermaid = $calcsByLanguage | ConvertTo-MermaidQuadrant -Title "Languages Efficiency"

        $markdown = $mermaid | Convert-MermaidToMarkdown

        return $markdown
    }
}