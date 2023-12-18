function Export-CopilotUsageTotals{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)][string]$Owner,
        [Parameter()][string]$OutputFile
    )

    process{

        $usage = Get-CopilotUsageOrg -Owner $Owner

        $csv = $usage | Convert-UsageToCsvTotals

        if($OutputFile){
            $csv | Out-File -FilePath $OutputFile
        } else {
            return $totals
        }
    }

} Export-ModuleMember -Function Export-CopilotUsageTotals

function Export-CopilotUsageBreakdown{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)][string]$Owner,
        [Parameter()][string]$OutputFile

    )

    process{

        $usage = Get-CopilotUsageOrg -Owner $Owner

        $csv = $usage | Convert-UsageToCsvBreakdown

        if($OutputFile){
            $csv | Out-File -FilePath $OutputFile
        } else {
            return $totals
        }

    }

} Export-ModuleMember -Function Export-CopilotUsageBreakdown


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
}


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