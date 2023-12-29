<#
.SYNOPSIS
    Export daily breakdown Copilot usage data of an organization to CSV.
#>
function Get-CopilotUsageOrgDiagramLanguageQuadrant{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)][string]$Owner
    )

    process{

        $usage = Get-CopilotUsageOrg -Owner $Owner

        $markdown = $usage | Convert-UsageToDiagramLanguageQuadrant

        return $markdown

    }

} Export-ModuleMember -Function Get-CopilotUsageOrgDiagramLanguageQuadrant