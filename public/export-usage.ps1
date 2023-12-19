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
    Gets daily Copilot usage data of an organization.
#>
function Get-CopilotUsageOrg{
    [CmdletBinding()]
    param(
        # owner
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)][string]$Owner
    )

    process{

        $owner = Get-EnvironmentOwner -Owner $Owner

        $usageJson = Invoke-MyCommand -Command CopilotUsageOrg -Parameters @{owner=$owner}

        $usage = $usageJson | ConvertFrom-Json -Depth 5

        return $usage
    }
} Export-ModuleMember -Function Get-CopilotUsageOrg

<#
.SYNOPSIS
    Gets daily Copilot usage data of an enterprise.
#>
function Get-CopilotUsageEnterprise{
    [CmdletBinding()]
    param(
        # owner
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)][string]$Enterprise
    )

    process{

        $Enterprise = Get-EnvironmentEnterprise -Enterprise $Enterprise

        $usageJson = Invoke-MyCommand -Command CopilotUsageEnterprise -Parameters @{enterprise=$Enterprise}

        $usage = $usageJson | ConvertFrom-Json -Depth 5

        return $usage
    }
} Export-ModuleMember -Function Get-CopilotUsageEnterprise

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

<#
.SYNOPSIS
    Covnerts the totals of Copilot usage data to CSV.
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
        $csv = $entries | ConvertTo-Csv -NoTypeInformation
        return $csv
    }
}

<#
.SYNOPSIS
    Covnerts the breakdown of Copilot usage data to CSV.
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
        $csv = $entries | ConvertTo-Csv -NoTypeInformation
        return $csv
    }
}

function Get-Ratio($a, $b){

    if($null -eq $a -or $null -eq $b){
        return 0
    }

    # parse $a and $b
    $a = [int64]$a
    $b = [int64]$b

    if($b -eq 0){
        return 0
    }
    return $a / $b
}