function GetConfiguration {
	[OutputType('pscustomobject')]
	[CmdletBinding()]
	param
	(
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$Region = $config:tokenRegion
	)

	$ErrorActionPreference = 'Stop'
	
	Get-Content -Path "$($PSScriptRoot | Split-Path -Parent)\configuration.json" | ConvertFrom-Json
}