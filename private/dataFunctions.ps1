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

function Get-CalcsWithRatios{
    [CmdletBinding()]
    param(
        # values
        [Parameter(Mandatory)][int64[]]$values,
        # Total
        [Parameter(Mandatory)][int64]$total
    )

    $calcs = Get-Calcs $values

    $calcs["ratio"] = Get-Ratio $calcs.average $total
    $calcs["ratio_round"] = [math]::Round($calcs.ratio,4)

    return $calcs
}

function Get-Totals($entries){

    $total_suggestions_count = $entries | Measure-Object -Property suggestions_count -Sum | Select-Object -ExpandProperty Sum
    $total_acceptances_count = $entries | Measure-Object -Property acceptances_count -Sum | Select-Object -ExpandProperty Sum
    $total_lines_suggested   = $entries | Measure-Object -Property lines_suggested   -Sum | Select-Object -ExpandProperty Sum
    $total_lines_accepted    = $entries | Measure-Object -Property lines_accepted    -Sum | Select-Object -ExpandProperty Sum
    $total_active_users      = $entries | Measure-Object -Property active_users      -Sum | Select-Object -ExpandProperty Sum

    return @{
        suggestions_count = $total_suggestions_count
        acceptances_count = $total_acceptances_count
        lines_suggested = $total_lines_suggested
        lines_accepted = $total_lines_accepted
        active_users = $total_active_users
    }
}

function Get-CalcsByProperty2($prop,$entries){

    $totals = Get-Totals $entries

    $groups =  $entries | Group-Object -Property $prop

    $ret = @{}

    $groups | ForEach-Object{
        $prop = @{}

        $prop["suggestions_count"] = Get-CalcsWithRatios -Values $_.Group.suggestions_count -Total $totals.suggestions_count
        $prop["acceptances_count"] = Get-CalcsWithRatios -Values $_.Group.acceptances_count -Total $totals.acceptances_count
        $prop["lines_suggested"]   = Get-CalcsWithRatios -Values $_.Group.lines_suggested   -Total $totals.lines_suggested
        $prop["lines_accepted"]    = Get-CalcsWithRatios -Values $_.Group.lines_accepted    -Total $totals.lines_accepted
        $prop["active_users"]      = Get-CalcsWithRatios -Values $_.Group.active_users      -Total $totals.active_users

        $ret[$_.Name] = $prop
    }

    return $ret
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

function Get-Round{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline)]
        [Double]$Value,
        [Parameter(Position=0)]
        [int]$Round = 2
    )

    process{
        return [math]::Round($Value,$Round)
    }
}