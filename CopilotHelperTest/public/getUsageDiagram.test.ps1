
function CopilotHelperTest_GetCopilotUsageDiagramOrg_Totals{

    $result = Get-CopilotUsageOrgDiagramTotals -Owner someOrgName

    Assert-Count -Expected 1 -Presented $result

    $counts =@'
``` mermaid
pie showData
  title Acceptance Count
  "Accepted": 3535
  "Not Accepted": 12467

```
'@

    $lines =@'
``` mermaid
pie showData
  title Acceptance Lines
  "Accepted": 5855
  "Not Accepted": 29151

```
'@

    Assert-IsTrue -Condition ($result.Contains($counts))
    Assert-IsTrue -Condition ($result.Contains($lines))
}

function CopilotHelperTest_GetCopilotUsageDiagramOrg_Breakdown{

    Assert-NotImplemented
    $result = Get-CopilotUsageOrgDiagramBreakdown -Owner someOrgName

    Assert-Count -Expected $($dataResultsBreakdownOrg + 2) -Presented $result
}

function CopilotHelperTest_GetCopilotUsageDiagramEnterprise_Breakdown{

    Assert-NotImplemented
    $result = Get-CopilotUsageEnterpriseDiagramBreakdown -Enterprise someEnterpriseName

    Assert-Count -Expected $($dataResultsBreakdownEnterprise + 2) -Presented $result
}