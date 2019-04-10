function ConvertTo-Speech {
	[OutputType('void')]
	[CmdletBinding(DefaultParameterSetName = 'StandardVoice')]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Text,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('raw-16khz-16bit-mono-pcm', 'raw-8khz-8bit-mono-mulaw',
			'riff-8khz-8bit-mono-alaw', 'riff-8khz-8bit-mono-mulaw',
			'riff-16khz-16bit-mono-pcm', 'audio-16khz-128kbitrate-mono-mp3',
			'audio-16khz-64kbitrate-mono-mp3', 'audio-16khz-32kbitrate-mono-mp3',
			'raw-24khz-16bit-mono-pcm', 'riff-24khz-16bit-mono-pcm',
			'audio-24khz-160kbitrate-mono-mp3', 'audio-24khz-96kbitrate-mono-mp3',
			'audio-24khz-48kbitrate-mono-mp3')]
		[string]$AudioOutput,

		[Parameter(Mandatory, ParameterSetName = 'StandardVoice')]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('ZiraRUS', 'JessaRUS', 'BenjaminRUS', 'Jessa24kRUS', 'Guy24kRUS', 'GuyNeural', 'JessaNeural')]
		[string]$VoiceAgent,

		[Parameter(Mandatory, ParameterSetName = 'CustomVoice')]
		[ValidateNotNullOrEmpty()]
		[string]$CustomEndpointUri,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$SSML,
		
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$OutputFile,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[switch]$PassThru
	)

	$ErrorActionPreference = 'Stop'

	if (-not $PSBoundParameters.ContainsKey('SSML')) {
		[xml]$xSsml = "<speak version='1.0' xml:lang='en-US'><voice xml:lang='en-US'></voice></speak>"
		
		$xSsml.speak.voice.InnerText = $Text
		if ($PSCmdlet.ParameterSetName -eq 'StandardVoice') {
			$attrib = $xSsml.speak.SelectSingleNode('voice').OwnerDocument.CreateAttribute('name')
			$attrib.Value = "Microsoft Server Speech Text to Speech Voice (en-US, $VoiceAgent)"
			$null = $xSsml.speak.SelectSingleNode('voice').Attributes.Append($attrib)
		}
		$SSML = $xSsml.InnerXml
	}
	
	$params = @{
		'Headers'    = @{'X-Microsoft-OutputFormat' = $AudioOutput }
		'Body'       = $SSML
		'OutputFile' = $OutputFile
	}
	if ($PSBoundParameters.ContainsKey('CustomEndpointUri')) {
		$params.Uri = $CustomEndpointUri
	}
	$file = InvokeConvertCsTsApi @params

	if ($PassThru.IsPresent) {
		$file
	}
}