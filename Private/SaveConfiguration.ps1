function SaveConfiguration {
	[OutputType('void')]
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Configuration
	)

	$ErrorActionPreference = 'Stop'
	
	$configFilePath = "$($PSScriptRoot | Split-Path -Parent)\configuration.json"
	$Configuration | Set-Content -Path $configFilePath
}