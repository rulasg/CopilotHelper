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
