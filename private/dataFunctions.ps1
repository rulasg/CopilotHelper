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

function Get-Calcs($a){

    # iterate $a and calculate agerage, total and count
    $total = 0
    $count = 0
    $a | ForEach-Object{
        $total += $_
        $count += 1
    }
    $average = $total / $count

    return @{
        average = $average
        average_round = [math]::Round($average)
        total = $total
        count = $count
    }
}

function Get-CalcsByProperty($prop,$entries){

    $groups =  $entries | Group-Object -Property $prop

    $ret = @{}

    $groups | ForEach-Object{
        $prop = @{}

        $prop["suggestions_count"] = Get-Calcs $_.Group.suggestions_count
        $prop["acceptances_count"] = Get-Calcs $_.Group.acceptances_count
        $prop["lines_suggested"] = Get-Calcs $_.Group.lines_suggested
        $prop["lines_accepted"] = Get-Calcs $_.Group.lines_accepted
        $prop["active_users"] = Get-Calcs $_.Group.active_users

        $ret[$_.Name] = $prop
    }

    return $ret
}

function Format-HashTablesByValue{
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory,ValueFromPipeline)]
        [Hashtable]$HashTables
    )

    process{
        $ret = [ordered]@{}

        $sorted = $HashTables.GetEnumerator() | Sort-Object -Property Value -Descending

        foreach($item in $sorted){
            $ret[$item.Name] = $item.Value
        }

        return $ret
    }
}

<#
Summary
    Selects the top $Percentage of HashTables by Value
#>
function Select-Top{
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory,ValueFromPipeline)]
        [Hashtable]$HashTable,
        [Parameter(Mandatory,Position=0)]
        [int]$Percentage
    )

    process{
        $ret = [ordered]@{}

        $sumValues = $HashTable.Values | Measure-Object -Sum | Select-Object -ExpandProperty Sum

        $sorted = $HashTable.GetEnumerator() | Sort-Object -Property Value -Descending

        $percentageValue = $sumValues * ($Percentage / 100)

        $currentSum = 0
        $top = 0

        foreach ($item in $sorted) {
            $currentSum += $item.Value
            $top += 1
            $ret[$item.Name] = $item.Value

            if ($currentSum -ge $percentageValue) {
                break
            }
        }

        $ret["Other"] = $sumValues - $currentSum

        return $ret
    }
}
