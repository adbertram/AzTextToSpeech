function Get-CsToken {
	[OutputType('pscustomobject')]
	[CmdletBinding()]
	param
	(
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$Key = $script:config.Key
	)

	$ErrorActionPreference = 'Stop'

	$headers = @{
		'Content-Length' = '0'
		'Key'            = $Key
	}
	
	$params = @{
		'Uri'         = $script:config.TokenEndpoint
		'ContentType' = 'application/x-www-form-urlencoded'
		'Headers'     = $headers
		'Method'      = 'POST'
	}
	InvokeApi @params
}