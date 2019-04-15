$ErrorActionPreference = 'Stop'

try {

	$manifestFilePath = "$env:APPVEYOR_BUILD_FOLDER\AzTextToSpeech.psd1"
	$manifestContent = Get-Content -Path $manifestFilePath -Raw

	## Update the module version based on the build version and limit exported functions
	$publicFunctions = Get-ChildItem -Path "$env:APPVEYOR_BUILD_FOLDER\Public" | Select-Object -ExpandProperty BaseName
	$functionsToExport = ($publicFunctions | foreach { "'$_'" }) -join ','
	$replacements = @{
		"ModuleVersion = '\*'"     = "ModuleVersion = '$env:APPVEYOR_BUILD_VERSION'"
		"FunctionsToExport = '\*'" = "FunctionsToExport = $functionsToExport"
	}		

	$replacements.GetEnumerator() | foreach {
		$manifestContent = $manifestContent -replace $_.Key, $_.Value
	}

	$env:APPVEYOR_BUILD_VERSION
	$manifestContent | Set-Content -Path $manifestFilePath

} catch {
	Write-Error -Message $_.Exception.Message
	$host.SetShouldExit($LastExitCode)
}