function GetApiKey {
	[OutputType('string')]
	[CmdletBinding()]
	param
	()

	$ErrorActionPreference = 'Stop'

	$config = GetConfiguration
	DecryptString -String ($script:config.APIKey)
}