
$DEFAULT_OWNER = "SolidifyDemo"
$DEFAULT_ENTERPRISE = "solidify-partner-demo"

function Get-EnvironmentOwner{
    [CmdletBinding()]
    param(
        [Parameter()] [string]$Owner
    )

    # Default owner
    if([string]::IsNullOrWhiteSpace($Owner)){
        $Owner = $DEFAULT_OWNER
    }

    return $Owner
}
function Get-EnvironmentEnterprise{
    [CmdletBinding()]
    param(
        [Parameter()] [string]$Enterprise
    )

    # Default owner
    if([string]::IsNullOrWhiteSpace($Enterprise)){
        $Enterprise = $DEFAULT_ENTERPRISE
    }

    return $Enterprise
}