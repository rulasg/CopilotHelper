<#
.SYNOPSIS
    Export daily totals Copilot usage data of an organization to CSV.
#>

function Get-CopilotUsageOrgMarkdownTotals{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)][string]$Owner
    )

    process{

        $usage = Get-CopilotUsageOrg -Owner $Owner

        $markdown = $usage | Convert-UsageToMarkdownTotals

        return $markdown
    }

} Export-ModuleMember -Function Get-CopilotUsageOrgMarkdownTotals

<#
.SYNOPSIS
    Export daily breakdown Copilot usage data of an organization to CSV.
#>
function Get-CopilotUsageOrgMarkdownBreakdown{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)][string]$Owner
    )

    process{

        $usage = Get-CopilotUsageOrg -Owner $Owner

        $markdown = $usage | Convert-UsageToMarkdownBreakdown

        return $markdown

    }

} Export-ModuleMember -Function Get-CopilotUsageOrgMarkdownBreakdown


<#
.SYNOPSIS
    Export daily breakdown Copilot usage data of an enterprise to CSV.
#>
function Get-CopilotUsageEnterpriseMarkdownBreakdown{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)][string]$Enterprise
    )

    process{

        $usage = Get-CopilotUsageEnterprise -Enterprise $Enterprise

        $markdown = $usage | Convert-UsageToMarkdownBreakdown

        return $markdown

    }

} Export-ModuleMember -Function Get-CopilotUsageEnterpriseMarkdownBreakdown

