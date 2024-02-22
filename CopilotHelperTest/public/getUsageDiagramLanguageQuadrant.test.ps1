
function CopilotHelperTest_GetCopilotUsageOrgDiagramLanguageQuadrant{

    Reset-InvokeCommandMock

    $owner = 'someOrgName'

    MockCall -Command "gh api orgs/$owner/copilot/usage" -filename $OrgTestDataFile

    $result = Get-CopilotUsageOrgDiagramLanguageQuadrant -Owner someOrgName

    $expected = @'
``` mermaid
quadrantChart
  title Languages Efficiency
  x-axis Low Lines --> High Lines
  y-axis Low Count --> High Count
  just: [0.45, 0.9]
  javascript: [0.45, 0.9]
  powershell: [0.45, 0.9]
  python: [0.45, 0.9]
  c#: [0.9, 1.8]
  go: [0.45, 0.9]

```

'@

    # Compare both string line by line. Mermaid has no strict line order

    $resultList = $result -split [System.Environment]::NewLine
    $expectedList = $expected -split [System.Environment]::NewLine

    Assert-Count -Expected 14 -Presented $resultList -Comment "Expected 14 lines in the result"

    Assert-AreEqual -Expected $expectedList.Length -Presented $resultList.Length

    for ($i = 0; $i -lt $expectedList.Length; $i++) {
        Assert-IsTrue -Condition ($resultList -contains $expectedList[$i]) -Comment "Comparing line $i"
    }
}