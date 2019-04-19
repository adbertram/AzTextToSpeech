function GetConfiguration {
	[OutputType('pscustomobject')]
	[CmdletBinding()]
	param
	()

	$ErrorActionPreference = 'Stop'
	
	$configFilePath = "$($PSScriptRoot | Split-Path -Parent)\configuration.json"
	if (-not (Test-Path -Path $configFilePath -PathType Leaf)) {
		throw "Required configuration file [$($configFilePath)] was not found."
	}
	$config = Get-Content -Path $configFilePath | ConvertFrom-Json

	$requiredAttributes = 'TokenEndpoint', 'SubscriptionRegion'
	$reqCogServAttributes = 'Name', 'ResourceGroupName'
	foreach ($attrib in $requiredAttributes) {
		if (-not $config.$attrib) {
			throw "[$($attrib)] in $configFilePath is not set."
		}
	}

	## Don't check if the API key is already in the configuration not needing the CognitiveServices accounts
	## or if this was called from Save-ApiKey where we are just now storing the API key
	if (-not $config.APIKey -and (-not (Get-PSCallStack)[0].Command -eq 'Save-ApiKey')) {
		foreach ($attrib in $reqCogServAttributes) {
			if (-not $config.CognitiveServicesAccount.$attrib) {
				throw "CognitiveServicesAccount [$($attrib)] in $configFilePath is not set."
			}
		}
	}

	if ($config.APIKey) {
		$config.APIKey = DecryptString -String $config.APIKey
	}
	$config
}