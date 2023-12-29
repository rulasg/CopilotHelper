
function CopilotHelperTest_GetCopilotUsageOrgDiagramLanguageQuadrant{

    $result = Get-CopilotUsageOrgDiagramLanguageQuadrant -Owner someOrgName

    Assert-IsTrue -condition ($result.Contains('title Languages Efficiency'))

    @(
        # Userts
        'title Languages Efficiency'
        'Others: [0.01, 0.02]',
        'c#: [0.9, 1.35]'

    ) | ForEach-Object {
        Assert-IsTrue -Condition $($result.Contains($_) -or $result[1].Contains($_)) -Comment $_
    }
}