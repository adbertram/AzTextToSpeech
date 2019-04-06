function Get-VoiceAgent {
	[OutputType('pscustomobject')]
	[CmdletBinding()]
	param
	(
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[uri]$Uri
	)

	$ErrorActionPreference = 'Stop'

	InvokeGetCsTsApi -Endpoint 'voices\list'
}