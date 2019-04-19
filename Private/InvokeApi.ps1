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
		[string]$OutFile,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$Body,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$ContentType,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[hashtable]$Headers
	)

	$ErrorActionPreference = 'Stop'

	$config = GetConfiguration

	if (-not (Get-Variable -Name 'config' -Scope 'Script' -ErrorAction Ignore)) {
		throw "Configuration not found. Have you ran Connect-AzTextToSpeech yet?"
	}

	if ($PSBoundParameters.ContainsKey('Headers')) {
		$Headers.Authorization = "Bearer $($script:config.Token)"
	} else {
		$Headers = @{
			'Authorization' = "Bearer $($script:config.Token)"
		}
	}

	try {
		$params = @{
			Headers = $Headers
			Method  = $Method
			Uri     = $Uri
		}
		if ($PSBoundParameters.ContainsKey('Body')) {
			$params.Body = $Body
		}
		if ($PSBoundParameters.ContainsKey('ContentType')) {
			$params.ContentType = $ContentType
		}
		if ($PSBoundParameters.ContainsKey('OutFile')) {
			$params.OutFile = $OutFile
		}
		$progBefore = $ProgressPreference
		$ProgressPreference = 'SilentlyContinue'
		Invoke-RestMethod @params
	} catch {
		if ($_.Exception.Message -eq 'The remote server returned an error: (401) Unauthorized.') {
			Write-Warning -Message 'API call not authorized. Attempting to refresh token...'
			RefreshCsToken
		} else {
			$PSCmdlet.ThrowTerminatingError($_)
		}
	} finally {
		$ProgressPreference = $progBefore
	}
}