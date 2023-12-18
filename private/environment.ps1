
$DEFAULT_OWNER = "SolidifyDemo"

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