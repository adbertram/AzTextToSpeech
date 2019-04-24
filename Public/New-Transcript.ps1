function New-Transcript {
	[OutputType('System.IO.FileInfo')]
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$RawTranscriptFilePath,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$RecordingFileFolderPath,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$TranscriptFilePath,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[switch]$Force,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[switch]$PassThru
	)

	$ErrorActionPreference = 'Stop'

	## Ensure all recordings are WAV files
	$recordings = Get-ChildItem -Path $RecordingFileFolderPath
	$recordings.foreach({ 
			if ($_.Extension -ne '.wav') {
				throw "The recording [$($_.Name)] is not a WAV file."
			} elseif ($_.BaseName -notmatch '\d+$') {
				throw 'The audio file name must be a digit.'
			}
		})
	$recordings = $recordings | Sort-Object -Property { $_.BaseName.ToString().PadLeft(10, '0') }
	
	$rawTranscriptLines = Get-Content -Path $RawTranscriptFilePath
	## Ensure there are an equal number of sentences in the raw text file that there are recordings
	if (@($rawTranscriptLines).Count -ne @($recordings).Count) {
		throw "One recording file must exist for every sentence in the raw transcript file. You currently have [$(@($rawTranscriptLines).Count)] lines in your transcript and [$(@($recordings).Count)] recording files."
	}

	## Build the transcript
	$transcriptText = ''
	
	for ($i = 0; $i -lt $recordings.Count; $i++) {
		$transcriptText += NewTranscriptRow -Text $rawTranscriptLines[$i] -AudioFileName $recordings[$i].BaseName
	}

	if ((Test-Path -Path $TranscriptFilePath -PathType Leaf) -and (-not $Force.IsPresent)) {
		throw "Existing transcript found and Force was not used to overwrite."
	}
	$transcriptText.Trim() | Set-Content -Path $TranscriptFilePath -NoNewline

	if ($PassThru.IsPresent) {
		Get-Item -Path $TranscriptFilePath
	}
}