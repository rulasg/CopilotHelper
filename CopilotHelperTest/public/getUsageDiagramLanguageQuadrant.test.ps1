
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

    Assert-AreEqual -Expected $expected -Presented $result
}