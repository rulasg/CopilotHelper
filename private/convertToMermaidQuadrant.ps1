# quadrantChart
#     title Reach and engagement of campaigns
#     x-axis Low Ratio --> High Ratio
#     y-axis Low Use --> High Use
#     quadrant-1 High Benefit
#     quadrant-2 Need to educate
#     quadrant-3 Low potential
#     quadrant-4 High Potential
#     Campaign A: [0.3, 0.6]
#     Campaign B: [0.45, 0.23]
#     Campaign C: [0.57, 0.69]
#     Campaign D: [0.78, 0.34]
#     Campaign E: [0.40, 0.34]
#     Campaign F: [0.35, 0.78]

function ConvertTo-MermaidQuadrant{
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)][string]$Title,
        [Parameter(Mandatory,ValueFromPipeline)]$Data
    )

    process{

        $mermaid =@()
        $mermaid += "quadrantChart"
        $mermaid += "  title $Title"
        $mermaid += "  x-axis Low Lines --> High Lines"
        $mermaid += "  y-axis Low Count --> High Count"
        # $mermaid += "  quadrant-1 High Benefit"
        # $mermaid += "  quadrant-2 Need to educate"
        # $mermaid += "  quadrant-3 Low potential"
        # $mermaid += "  quadrant-4 High Potential"

        # Filter Data that has a ratio of 0
        $toPaint = @{}
        $zeroes = @{}
        $threshold = 0.001
        $itemPattern = "  {0}: [{1}, {2}]"
        $others = @{}
        $Data.GetEnumerator() | ForEach-Object {
            $y = $_.Value.suggestions_count.ratio_round
            $x = $_.Value.lines_accepted.ratio_round

            if(($x -ne 0) -and ($y -ne 0)){
                if(($x -ge $threshold) -and ($y -ge $threshold)){
                    $toPaint[$_.Key] = ToCoordenates $x $y
                } else {
                    $others[$_.Key] = ToCoordenates $x $y
                }
            } else {
                $zeroes[$_.Key] = ToCoordenates $x $y
            }
 
        }

        #Others
        if($others.Count -gt 0){
            $othersX = $others.Values.x | Measure-Object -Average | Select-Object -ExpandProperty Average 
            $othersY = $others.Values.y | Measure-Object -Average | Select-Object -ExpandProperty Average
            $toPaint["Others"] += ToCoordenates $othersX $othersY
        }

        $maxratio = 0.90

        $maxX = $toPaint.Values.x | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
        $maxY = $toPaint.Values.y | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
        
        $toPaint.GetEnumerator() | ForEach-Object {
            $x =  $_.Value.x * $maxratio / $maxX | Get-Round
            $y = $_.Value.x  * $maxratio / $maxY | Get-Round

            $mermaid += $itemPattern -f $_.Key,$x,$y
        }
        
        $ret = $mermaid | Out-String
        
        return $ret
    }
}
function ToCoordenates($x,$y){
    return @{
        x = $x
        y = $y
    }
}