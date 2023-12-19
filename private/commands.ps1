# Set the commands alias for later use in the application

Set-InvokeCommandAlias -Alias CopilotUsageOrg        -Command 'gh api orgs/{owner}/copilot/usage'
Set-InvokeCommandAlias -Alias CopilotUsageEnterprise -Command 'gh api enterprises/{enterprise}/copilot/usage'