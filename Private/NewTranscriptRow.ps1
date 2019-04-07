function NewTranscriptRow {
	[OutputType('string')]
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[string]$Text,

		[Parameter(Mandatory)]
		[string]$AudioFileName
	)

	$ErrorActionPreference = 'Stop'

	"$($AudioFileName.replace('.wav',''))`t$Text`n"
}