function TestAzAuthenticated {
	[OutputType('bool')]
	[CmdletBinding()]
	param
	()

	$ErrorActionPreference = 'Stop'

	if (-not (Get-AzContext)) {
		$false
	} else {
		$true
	}
}