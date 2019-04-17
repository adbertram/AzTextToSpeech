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