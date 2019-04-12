function New-TrainingDataPackage {
	[OutputType('')]
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$RecordingFileFolder,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$TranscriptFilePath,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$ZipFilePath,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[switch]$Force
	)

	$ErrorActionPreference = 'Stop'

	$audioFileNames = (Get-Content -Path $TranscriptFilePath).foreach({ $_.split("`t")[0] }) | Get-Unique

	$recordings = Get-ChildItem -Path $RecordingFileFolder
	$recordings.foreach({
			if ($_.BaseName -notin $audioFileNames) {
				throw "The recording [$($_.Name)] is not in the transcript."
			}
		})
	
	$compressParams = @{
		DestinationPath = $ZipFilePath
	}
	if ($Force.IsPresent) {
		$compressParams.Force = $true
	}
	$recordings | Compress-Archive @compressParams
}