function Get-CsToken {
	[OutputType('pscustomobject')]
	[CmdletBinding()]
	param
	(
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$Key = $script:config.Key,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$Uri = $script:config.TokenEndpoint
	)

	$ErrorActionPreference = 'Stop'

	$headers = @{
		'Content-Length' = '0'
		'Key'            = $Key
	}
	
	$params = @{
		'Uri'         = $Uri
		'ContentType' = 'application/x-www-form-urlencoded'
		'Headers'     = $headers
		'Method'      = 'POST'
	}
	InvokeApi @params
}