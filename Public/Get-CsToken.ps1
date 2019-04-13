function Get-CsToken {
	[OutputType('pscustomobject')]
	[CmdletBinding()]
	param
	()

	$ErrorActionPreference = 'Stop'

	$config = GetConfiguration

	$params = @{
		ResourceGroupName = $config.CognitiveServicesAccount.ResourceGroupName
		Name              = $config.CognitiveServicesAccount.Name
	}
	$keys = Get-AzCognitiveServicesAccountKey @params

	$headers = @{
		'Ocp-Apim-Subscription-Key' = $keys.Key1
		'Content-Length'            = '0'
	}

	$params = @{
		'Uri'         = $config.TokenEndpoint
		'ContentType' = 'application/x-www-form-urlencoded'
		'Headers'     = $headers
		'Method'      = 'POST'
	}
	InvokeApi @params
}