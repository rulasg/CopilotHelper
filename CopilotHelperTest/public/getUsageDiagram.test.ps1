
function CopilotHelperTest_GetCopilotUsageDiagramOrg_Totals{

    Reset-InvokeCommandMock

    $owner = 'someOrgName'

    MockCall -Command "gh api orgs/$owner/copilot/usage" -filename $OrgTestDataFile

    $result = Get-CopilotUsageOrgDiagramTotals -Owner $owner

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

# ``` mermaid
# pie showData
#   title active_users [432]
#   "Other": 103
#   "typescript": 54
#   "markdown": 46
#   "powershell": 44
#   "javascript": 31
#   "json": 25
#   "github-actions-workflow": 22
#   "text": 21
#   "json with comments": 20
#   "c#": 18
#   "python": 17
#   "bicep": 16
#   "yaml": 15

# ```

# ``` mermaid
# pie showData
#   title lines_accepted [5855]
#   "powershell": 1574
#   "Other": 1370
#   "javascript": 1002
#   "c#": 886
#   "python": 531
#   "typescript": 492

# ```

    Reset-InvokeCommandMock

    $owner = 'someOrgName'

    MockCall -Command "gh api orgs/$owner/copilot/usage" -filename $OrgTestDataFile

    $result = Get-CopilotUsageOrgDiagramBreakdown -Owner $owner

    @(
        # Userts
        'title active_users [432]'
        '"Other": 103',

        # Lines
        'title lines_accepted [5855]',
        '"Other": 1370'

    ) | ForEach-Object {
        Assert-IsTrue -Condition $($result[0].Contains($_) -or $result[1].Contains($_))
    }

}

function CopilotHelperTest_GetCopilotUsageDiagramEnterprise_Breakdown{

# ``` mermaid
# pie showData
#   title active_users [864]
#   "Other": 206
#   "typescript": 108
#   "markdown": 92
#   "powershell": 88
#   "javascript": 62
#   "json": 50
#   "github-actions-workflow": 44
#   "text": 42
#   "json with comments": 40
#   "c#": 36
#   "python": 34
#   "bicep": 32
#   "yaml": 30

# ```

# ``` mermaid
# pie showData
#   title lines_accepted [11710]
#   "powershell": 3148
#   "Other": 2740
#   "javascript": 2004
#   "c#": 1772
#   "python": 1062
#   "typescript": 984

# ```
    Reset-InvokeCommandMock

    $owner = 'someEnterpriseName'

    MockCall -Command "gh api enterprises/$owner/copilot/usage" -filename $EnterpriseTestDataFile

    $result = Get-CopilotUsageEnterpriseDiagramBreakdown -Enterprise $owner

    @(
        # Userts
        'title active_users [864]'
        '"Other": 206',

        # Lines
        'title lines_accepted [11710]',
        '"Other": 2740'

    ) | ForEach-Object {
        Assert-IsTrue -Condition $($result[0].Contains($_) -or $result[1].Contains($_))
    }
}