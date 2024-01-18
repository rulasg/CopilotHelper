
if (!$SET_INVOKE_COMMAND_MOCK_LOADED){
    $SET_INVOKE_COMMAND_MOCK_LOADED = $true

    # Managing dependencies
    $MODULE_INVOKATION_TAG = "CopilotHelperModule_Mock"

    function Set-InvokeCommandMock{
        [CmdletBinding(SupportsShouldProcess)]
        param(
            [Parameter(Mandatory,Position=0)][string]$Alias,
            [Parameter(Mandatory,Position=1)][string]$Command
        )

        if ($PSCmdlet.ShouldProcess("InvokeCommandAliasList", ("Add Command Alias [{0}] = [{1}]" -f $Alias, $Command))) {
            InvokeHelper\Set-InvokeCommandAlias -Alias $Alias -Command $Command -Tag $MODULE_INVOKATION_TAG
        }
    }

}