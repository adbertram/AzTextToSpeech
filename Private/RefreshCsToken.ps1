function RefreshCsToken {
	[OutputType('pscustomobject')]
	[CmdletBinding()]
	param
	()

	$ErrorActionPreference = 'Stop'

	$headers = @{
		'Ocp-Apim-Subscription-Key' = $script:config.APIKey
		'Content-Length'            = '0'
	}

	$params = @{
		'Uri'         = $script:config.TokenEndpoint
		'ContentType' = 'application/x-www-form-urlencoded'
		'Headers'     = $headers
		'Method'      = 'POST'
	}
	
	$token = Invoke-RestMethod @params
	$script:config | Add-Member -NotePropertyName 'Token' -NotePropertyValue $token -Force
	$script:config | Add-Member -NotePropertyName 'TokenRefreshTime' -NotePropertyValue (Get-Date) -Force
}