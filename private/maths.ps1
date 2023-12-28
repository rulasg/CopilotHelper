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
        total = $total
        count = $count
    }
}