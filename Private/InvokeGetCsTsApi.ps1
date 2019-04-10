function InvokeGetCsTsApi {
	[OutputType('pscustomobject')]
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Endpoint
	)

	$ErrorActionPreference = 'Stop'

	if (-not (Get-Variable -Name 'config' -Scope 'Script' -ErrorAction 'Ignore')) {
		throw 'Could not find session configuration. Have you ran Connect-AzSpeechToText yet?'
	}
	
	$headers = @{
		'Authorization' = "Bearer $($script:config.Token)"
	}

	try {
		$params = @{
			Headers = $headers
			Method  = 'GET'
			Uri     = "https://$($script:config.SubscriptionRegion).tts.speech.microsoft.com/cognitiveservices/$Endpoint"
		}
		Invoke-RestMethod @params
	} catch {
		if ($_.Exception.Message -eq 'The remote server returned an error: (401) Unauthorized.') {
			RefreshCsToken
			InvokeGetCsTsApi @PSBoundParameters
		} else {
			$PSCmdlet.ThrowTerminatingError($_)
		}
	}
}