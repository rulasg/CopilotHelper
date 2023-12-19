
# This script will update the test data files forl ater use in unit testing

$result = gh api 'orgs/solidifyDemo/copilot/usage'
$result | Out-File -FilePath kk1.log

$result = gh api 'enterprises/solidify-partner-demo/copilot/usage'
$result | Out-File -FilePath kk2.log