function Connect-AzSpeechToText {
	[OutputType('pscustomobject')]
	[CmdletBinding()]
	param
	()

	$ErrorActionPreference = 'Stop'

	if (-not (TestAzAuthenticated)) {
		throw 'You are currently not authenticated to Azure. First run Connect-AzAccount to authenticate.'
	}

	$script:config = GetConfiguration

	$params = @{
		ResourceGroupName = $script:config.CognitiveServicesAccount.ResourceGroupName
		Name              = $script:config.CognitiveServicesAccount.Name
	}

	$keys = Get-AzCognitiveServicesAccountKey @params
	$script:config | Add-Member -NotePropertyName 'Key' -NotePropertyValue $keys.Key1
	RefreshCsToken
}