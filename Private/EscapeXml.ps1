function EscapeXml {
	[OutputType('string')]
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Xml
	)

	$ErrorActionPreference = 'Stop'

	$replacements = @{
		"'" = 'apos'
		'"' = 'quot'
		'&' = 'amp'
		'<' = 'lt'
		'>' = 'gt'
	}
	foreach ($repl in $replacements.GetEnumerator()) {
		$Xml = $Xml -replace $repl.Key, "&$($repl.Value)"
	}
	$Xml
}