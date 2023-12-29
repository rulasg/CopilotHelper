function ConvertTo-MermaidPieTotalAndPositive{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][string]$Title,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][string]$Name,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][int64]$Total,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][int64]$Positive
    )
    process{

        $data = [ordered]@{
            "$Name" = $Positive
            "Not $Name" = $($Total - $Positive)
        }
        $mermaid = ConvertTo-MermaidPie -Title $Title -Data $data

        return $mermaid
    }
}

function ConvertTo-MermmaidPieTopPercentage{
    [CmdletBinding()]
    param(
        # Hash table of data to convert to pie chart.
        [Parameter(Mandatory,ValueFromPipeline)][hashtable]$Data,
        # Attribute name to use for sorting.
        [Parameter(Mandatory)][string]$TargetAttribute,
        # top percentage to show.
        [Parameter()][int]$TopPercentage = 75
    )

    process{
        $languages = @{}

        $calcsByLanguage.GetEnumerator() | ForEach-Object {
            $languages[$_.Name] = $_.Value.$TargetAttribute.total
        }
        $data = $languages | Select-Top $TopPercentage | Format-HashTablesByValue

        $total = $languages.Values | Measure-Object -Sum | Select-Object -ExpandProperty Sum

        $title = "$TargetAttribute [$total]"

        $mermaid += ConvertTo-MermaidPie -Title $title -Data $data

        return $mermaid
    }
}


function ConvertTo-MermaidPie{
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)][string]$Title,
        [Parameter(Mandatory)]$Data
    )

    $mermaid =@()
    $mermaid += "pie showData"
    $mermaid += "  title $Title"

    $Data.GetEnumerator() | ForEach-Object {
        $mermaid += "  `"$($_.Key)`": $($Data.$($_.Key))"
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