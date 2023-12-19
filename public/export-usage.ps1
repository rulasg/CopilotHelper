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

function Get-CopilotUsageEnterprise{
    [CmdletBinding()]
    param(
        # owner
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)][string]$Enterprise
    )

    process{

        $owner = Get-EnvironmentEnterprise -Enterprise $Enterprise

        $usageJson = Invoke-MyCommand -Command CopilotUsageEnterprise -Parameters @{enterprise=$Enterprise}

        $usage = $usageJson | ConvertFrom-Json -Depth 5

        return $usage
    }
} Export-ModuleMember -Function Get-CopilotUsageEnterprise

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
            total_suggestions_count = $Entry.total_suggestions_count
            total_acceptances_count = $Entry.total_acceptances_count
            total_lines_suggested = $Entry.total_lines_suggested
            total_lines_accepted = $Entry.total_lines_accepted
            total_active_users = $Entry.total_active_users
            day = $Entry.day
            entry_type = "Total"
        }
    }

    end {
        $csv = $entries | ConvertTo-Csv -NoTypeInformation
        return $csv
    }
}

function Convert-UsageToCsvBreakdown{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline)][Object]$Entry
    )

    begin {
        $entries = @()
    }

    process {
        $entries += $Entry.breakdown | ForEach-Object {
            @{
                language = $_.language
                editor = $_.editor
                suggestions_count = $_.suggestions_count
                acceptances_count = $_.acceptances_count
                lines_suggested = $_.lines_suggested
                lines_accepted = $_.lines_accepted
                active_users = $_.active_users
                day = $Entry.day
                entry_type = "Breakdown"
            }
        }
    }

    end {
        $csv = $entries | ConvertTo-Csv -NoTypeInformation
        return $csv
    }
}