function SplitSentences {
	[OutputType('pscustomobject')]
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$RawTranscriptFilePath
	)

	$ErrorActionPreference = 'Stop'

	(Get-Content -Path $RawTranscriptFilePath -Raw) -replace '(\.|\?|\!)\s+', "`$1~" -split '~'
}