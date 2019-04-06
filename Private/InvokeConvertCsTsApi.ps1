function InvokeConvertCsTsApi {
	[OutputType('pscustomobject')]
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Body,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[hashtable]$Headers,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$OutputFile,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$Endpoint = 'v1'
	)

	$ErrorActionPreference = 'Stop'

	if (-not (Get-Variable -Name 'config' -Scope 'Script' -ErrorAction 'Ignore')) {
		throw 'Could not find session configuration. Have you ran Connect-AzSpeechToText yet?'
	}
	
	$authHeaders = @{
		'Authorization' = "Bearer $($script:config.Token)"
	}
	if ($PSBoundParameters.ContainsKey('Headers')) {
		$headers = $authHeaders + $Headers
	} else {
		$headers = $authHeaders
	}

	$params = @{
		Headers     = $Headers
		ContentType = 'application/ssml+xml'
		Method      = 'POST'
		Body        = $Body
		Uri         = "https://$($script:config.SubscriptionRegion).tts.speech.microsoft.com/cognitiveservices/$Endpoint"
		OutFile     = $OutputFile
	}
	Invoke-RestMethod @params
	Get-Item -Path $OutputFile
}