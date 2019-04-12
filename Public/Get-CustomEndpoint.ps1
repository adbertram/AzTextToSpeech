function Get-CustomEndpoint {
	[OutputType('pscustomobject')]
	[CmdletBinding(SupportsShouldProcess)]
	param
	()

	$ErrorActionPreference = 'Stop'

	(Get-Content -Path "$($PSScriptRoot | Split-Path -Parent)\configuration.json" | ConvertFrom-Json).CustomEndpoints
}