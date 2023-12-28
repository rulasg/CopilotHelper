<#
.SYNOPSIS
    Export daily totals Copilot usage data of an organization to CSV.
#>

function Get-CopilotUsageOrgDiagramTotals{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)][string]$Owner
    )

    process{

        $usage = Get-CopilotUsageOrg -Owner $Owner

        $markdown = $usage | Convert-UsageToDiagramTotals

        return $markdown
    }

} Export-ModuleMember -Function Get-CopilotUsageOrgDiagramTotals

<#
.SYNOPSIS
    Export daily breakdown Copilot usage data of an organization to CSV.
#>
function Get-CopilotUsageOrgDiagramBreakdown{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)][string]$Owner
    )

    process{

        $usage = Get-CopilotUsageOrg -Owner $Owner

        $markdown = $usage | Convert-UsageToDiagramBreakdown

        return $markdown

    }

} Export-ModuleMember -Function Get-CopilotUsageOrgDiagramBreakdown


<#
.SYNOPSIS
    Export daily breakdown Copilot usage data of an enterprise to CSV.
#>
function Get-CopilotUsageEnterpriseDiagramBreakdown{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)][string]$Enterprise
    )

    process{

        $usage = Get-CopilotUsageEnterprise -Enterprise $Enterprise

        $markdown = $usage | Convert-UsageToDiagramBreakdown

        return $markdown

    }

} Export-ModuleMember -Function Get-CopilotUsageEnterpriseDiagramBreakdown

