function Connect-AzTextToSpeech {
	<#
		.SYNOPSIS
			Queries your Cognitive Services account for the first API key and uses it to find a token. Once found,
			stores the token in the module scope to be used for all API calls throughout the time the module
			is imported.

			Depends on values already being set up in the module folder's configuration.json file and also being
			authenticated to your Azure account.
	
		.EXAMPLE
			PS> Connect-AzTextToSpeech
	
	#>
	[OutputType('pscustomobject')]
	[CmdletBinding()]
	param
	()

	$ErrorActionPreference = 'Stop'

	$script:config = GetConfiguration
	if (-not $script:config.APIKey) {
		if (-not (TestAzAuthenticated)) {
			throw 'You are currently not authenticated to Azure and no API key is saved. First run Connect-AzAccount to authenticate or sign up for a free API key and run Save-ApiKey.'
		}

		$params = @{
			ResourceGroupName = $script:config.CognitiveServicesAccount.ResourceGroupName
			Name              = $script:config.CognitiveServicesAccount.Name
		}

		$keys = Get-AzCognitiveServicesAccountKey @params
		$script:config.APIKey = $keys.Key1
	}
	RefreshCsToken
}