function Save-ApiKey {
	[OutputType('void')]
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Key
	)

	$ErrorActionPreference = 'Stop'

	$config = GetConfiguration
	$config.APIKey = EncryptString -String $Key
	if (Get-Variable -Name 'config' -Scope 'Script' -ErrorAction Ignore) {
		$script:config.APIKey = $Key
	}
	SaveConfiguration -Configuration ($config | ConvertTo-Json -Depth 3)
}