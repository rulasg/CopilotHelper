function ConvertTo-MarkdownTable{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline)][PSCustomObject]$InputObject
    )

    begin {
        $markdown = @()
        $first = $true
    }

    process {
        if($first){
            $markdown += $InputObject | Get-MarkdownHeadersTotal
            $first = $false
        }

        $markdown += $InputObject | Get-UsageBreakdownToMarkdownLine
    }

    end {
        return $markdown
    }
}
function Get-MarkdownHeadersTotal{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline)][PSCustomObject]$InputObject

    )

    process {

        $l1 = ""
        $l2 = ""

        $InputObject.Keys | ForEach-Object{
            $l1 += "| $_ "
            $l2 += "| --- "
        }
        $l1 += "|"
        $l2 += "|"

        $l1 | Write-Output
        $l2 | Write-Output
    }
}

function Get-UsageBreakdownToMarkdownLine{
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory,ValueFromPipeline)][PSCustomObject]$Entry
    )

    begin{
        $lines = @()
    }

    process{

        $line = ""

        $entry.Keys | ForEach-Object{
            $line += "| $($entry.$_.ToString()) "
        }
        $line += "|"

        $lines += $line
    }

    end{
        return $lines
    }
}