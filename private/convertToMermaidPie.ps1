function ConvertTo-MermaidPieTotalAndTrue{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][string]$Title,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][string]$Name,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][int64]$Total,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][int64]$Positive
    )
    $mermaid = ConvertTo-MermaidPie -Title $Title -Data @{
        "$Name" = $Positive
        "Not $Name" = $($Total - $Positive)
    }

    return $mermaid
}

function ConvertTo-MermaidPie{
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)][string]$Title,
        [Parameter(Mandatory)][hashtable]$Data
    )

    $mermaid =@()
    $mermaid += "pie showData"
    $mermaid += "  title $Title"

    $Data.Keys | ForEach-Object {
        $mermaid += "  `"$($_)`": $($Data.$_)"
    }

    $ret = $mermaid | Out-String

    return $ret
}

function Convert-MermaidToMarkdown{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline)][string]$Mermaid
    )

    process {
        $markdown = @()

        $markdown += '``` mermaid'
        $markdown += $mermaid
        $markdown += '```'

        return $markdown | Out-String
    }
}