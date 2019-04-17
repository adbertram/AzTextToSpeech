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
	foreach ($attrib in $reqCogServAttributes) {
		if (-not $config.CognitiveServicesAccount.$attrib) {
			throw "CognitiveServicesAccount [$($attrib)] in $configFilePath is not set."
		}
	}
	$config
}