function Get-VoiceAgent {
	[OutputType('pscustomobject')]
	[CmdletBinding()]
	param
	()

	$ErrorActionPreference = 'Stop'

	InvokeApi -Uri 'https://eastus.tts.speech.microsoft.com/cognitiveservices/voices/list' -Method 'GET'
}