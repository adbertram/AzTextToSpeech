function InvokeApi {
	[OutputType('pscustomobject')]
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Uri,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Method,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$ContentType,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[hashtable]$Headers
	)

	$ErrorActionPreference = 'Stop'

	$config = GetConfiguration

	if ($PSBoundParameters.ContainsKey('Headers')) {
		$Headers.Authorization = "Bearer $($config.Token)"
	} else {
		$Headers = @{
			'Authorization' = "Bearer $($token)"
		}
	}

	try {
		$params = @{
			Headers = $Headers
			Method  = $Method
			Uri     = $Uri
		}
		if ($PSBoundParameters.ContainsKey('ContentType')) {
			$params.ContentType = $ContentType
		}
		Invoke-RestMethod @params
	} catch {
		if ($_.Exception.Message -eq 'The remote server returned an error: (401) Unauthorized.') {
			RefreshCsToken
			InvokeApi -Uri $Uri -Method $Method -Headers $Headers
		} else {
			$PSCmdlet.ThrowTerminatingError($_)
		}
	}
}