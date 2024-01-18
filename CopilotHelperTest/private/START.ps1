# Gate to be loaded only onces
if (! $LOADED_EARLYLOADED){
    $LOADED_EARLYLOADED = $true

    # TODO: Add all modules that requies to be loadd before the code modules.
    # This is useful when you have a dependency to run


    # Import Set-MyInvokeCommandAlias
    . $(($PSScriptRoot | Join-Path -ChildPath SetInvokeCommandMock.ps1 | Get-Item).FullName)

}

