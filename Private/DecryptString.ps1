function DecryptString {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$String
	)

	$secure = ConvertTo-SecureString $String
	$hook = New-Object system.Management.Automation.PSCredential("test", $secure)
	$hook.GetNetworkCredential().Password
}