<#
.SYNOPSIS
    Export daily totals Copilot usage data of an organization to CSV.
#>
function Export-CopilotUsageOrgTotals{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)][string]$Owner,
        [Parameter(Mandatory)][string]$OutputFile
    )

    process{

        $usage = Get-CopilotUsageOrg -Owner $Owner

        $csv = $usage | Convert-UsageToCsvTotals

        $csv | Out-File -FilePath $OutputFile
    }

} Export-ModuleMember -Function Export-CopilotUsageOrgTotals

<#
.SYNOPSIS
    Export daily breakdown Copilot usage data of an organization to CSV.
#>
function Export-CopilotUsageOrgBreakdown{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)][string]$Owner,
        [Parameter(Mandatory)][string]$OutputFile

    )

    process{

        $usage = Get-CopilotUsageOrg -Owner $Owner

        $csv = $usage | Convert-UsageToCsvBreakdown

        $csv | Out-File -FilePath $OutputFile

    }

} Export-ModuleMember -Function Export-CopilotUsageOrgBreakdown

<#
.SYNOPSIS
    Export daily breakdown Copilot usage data of an enterprise to CSV.
#>
function Export-CopilotUsageEnterpriseBreakdown{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)][string]$Enterprise,
        [Parameter(Mandatory)][string]$OutputFile

    )

    process{

        $usage = Get-CopilotUsageEnterprise -Enterprise $Enterprise

        $csv = $usage | Convert-UsageToCsvBreakdown

        $csv | Out-File -FilePath $OutputFile

    }

} Export-ModuleMember -Function Export-CopilotUsageEnterpriseBreakdown


