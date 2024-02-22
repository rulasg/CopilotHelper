
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

    # Compare both string line by line to avoid differnnces with new lines charecters between systems

    $resultList = $result -split [System.Environment]::NewLine
    $expectedList = $expected -split [System.Environment]::NewLine

    for ($i = 0; $i -lt $resultList.Length; $i++) {
        Assert-AreEqual -Expected $expectedList[$i] -Presented $resultList[$i]
    }

}