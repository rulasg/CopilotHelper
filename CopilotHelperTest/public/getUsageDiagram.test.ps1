
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
    $users =@'
``` mermaid
pie showData
  title active_users [432]
  "Other": 103
  "typescript": 54
  "markdown": 46
  "powershell": 44
  "javascript": 31
  "json": 25
  "github-actions-workflow": 22
  "text": 21
  "json with comments": 20
  "c#": 18
  "python": 17
  "bicep": 16
  "yaml": 15

```

'@

    $lines =@'
``` mermaid
pie showData
  title lines_accepted [5855]
  "powershell": 1574
  "Other": 1370
  "javascript": 1002
  "c#": 886
  "python": 531
  "typescript": 492

```

'@

    $result = Get-CopilotUsageOrgDiagramBreakdown -Owner someOrgName

    Assert-Contains -Expected $users -Presented $result
    Assert-Contains -Expected $lines -Presented $result
}

function CopilotHelperTest_GetCopilotUsageDiagramEnterprise_Breakdown{

    Assert-NotImplemented
    $result = Get-CopilotUsageEnterpriseDiagramBreakdown -Enterprise someEnterpriseName

    Assert-Count -Expected $($dataResultsBreakdownEnterprise + 2) -Presented $result
}