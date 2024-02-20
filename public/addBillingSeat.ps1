# REF: https://docs.github.com/en/rest/copilot/copilot-business?apiVersion=2022-11-28#add-users-to-the-copilot-business-subscription-for-an-organization

Set-MyInvokeCommandAlias -Alias RemoveBillingUser -Command 'gh api --method DELETE /orgs/{owner}/copilot/billing/selected_users -f "selected_usernames[]={user}"'
Set-MyInvokeCommandAlias -Alias AddBillingUser -Command 'gh api --method POST /orgs/{owner}/copilot/billing/selected_users -f "selected_usernames[]={user}"'


<#
.SYNOPSIS
    Remove a user from the billing seats for an organization.
#>
function Remove-CopilotBillingUser{
    [CmdletBinding()]
    param(
        [Parameter()][string]$Owner,
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)][string]$User
    )

    process {
        $environment = Get-EnvironmentOwner -Owner $Owner

        $param = @{'owner' = $environment; 'user' = $User}

        $result = Invoke-MyCommandJson -Command RemoveBillingUser -Param $param

        if($null -eq $result){
            "Error calling RemoveBillingUser with [$owner] and [$user]" | Write-Error
            $ret = $null
            return
        } elseif ($result.message -eq "Not Found"){
            "Error calling RemoveBillingUser with [$owner] and [$user] - $($result.message)" | Write-Error
            $ret = $null
            return
        } elseif ($null -ne $result.message){
            "Error calling RemoveBillingUser with [$owner] and [$user] - $($result.message)" | Write-Error
            $ret = $null
            return
        } elseif ($null -eq $result.message){
            $ret = $result
        } else {
            throw "we should never reach this point"
        }

        return $ret
    }
} Export-ModuleMember -Function Remove-CopilotBillingUser

<#
.SYNOPSIS
    Add a user to the billing seats for an organization.
#>
function Add-CopilotBillingUser{
    [CmdletBinding()]
    param(
        [Parameter()][string]$Owner,
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)][string]$User
    )

    process {
        $environment = Get-EnvironmentOwner -Owner $Owner

        $param = @{'owner' = $environment; 'user' = $User}

        $result = Invoke-MyCommandJson -Command AddBillingUser -Param $param

        if($null -eq $result){
            "Error calling AddBillingUser with [$owner] and [$user]" | Write-Error
            $ret = $null
            return
        } elseif ($result.message -eq "Not Found"){
            "Error calling AddBillingUser with [$owner] and [$user] - $($result.message)" | Write-Error
            $ret = $null
            return
        } elseif ($null -ne $result.message){
            "Error calling AddBillingUser with [$owner] and [$user] - $($result.message)" | Write-Error
            $ret = $null
            return
        } elseif ($null -eq $result.message){
            $ret = $result
        } else {
            throw "we should never reach this point"
        }

        return $ret
    }
} Export-ModuleMember -Function Add-CopilotBillingUser