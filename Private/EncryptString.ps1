function EncryptString {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$String
	)

	$secure = ConvertTo-SecureString $String -AsPlainText -Force
	$secure | ConvertFrom-SecureString
}