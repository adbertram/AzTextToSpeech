function ConvertTo-Speech {
	<#
		.SYNOPSIS
			Converts text to speech by calling an Azure Speech Services text to speech API and returning the result.

		.PARAMETER Text
			A mandatory (when not using the SSML parameter) string representing the text to convert to speech. If the SSML
			parameter is used, the text to convert will be held in there.

		.PARAMETER AudioOutput
			A mandatory string representing the audio format the output file will be in once returned. Use the tab key to auto-complete
			available options.

		.PARAMETER VoiceAgent
			A mandatory (when using the VoiceAgent parameter) string representing the Cognitive Services voice agent 
			to use to dicate the text. Use the tab key to auto-complete available options. This parameter cannot be used 
			with CustomEndpointUri or SSML.

		.PARAMETER CustomEndpointUri
			A mandatory (when not using the VoiceAgent parameter) uri representing a custom endpoint created after 
			creating a custom voice font.
		
		.PARAMETER SSML
			A mandatory (when not using the VoiceAgent or CustomEndpointUri parameters) string parameter representing 
			SSML to pass to the API. By default, this SSML is created for you automatically and passed to the API. 
			Use this option to craft custom SSML.

		.PARAMETER OutputFile
			A mandatory string parameter representing the path to save the audio file that is returned.

		.PARAMETER PassThru
			A switch parameter to use if you'd like the output file returned as a System.IO.FileInfo object. By default,
			the file is just saved. Use this to return the file.
	
		.EXAMPLE
			PS> ConvertTo-Speech -Text 'Hello, how are you?' -AudioOutput 'audio-16khz-64kbitrate-mono-mp3' -VoiceAgent 'ZiraUS' -OutputFile 'C:\test.mp3'

			This example will instruct the ZiraUS voice to dicate 'Hello, how are you?' returning a audio-16khz-64kbitrate-mono-mp3
			audio file and saving it as C:\test.mp3.

		.EXAMPLE
			PS> ConvertTo-Speech -Text 'Hello, how are you?' -AudioOutput 'audio-16khz-64kbitrate-mono-mp3' -VoiceAgent 'ZiraUS' -OutputFile 'C:\test.mp3'

			This example will instruct the ZiraUS voice to dicate 'Hello, how are you?' returning a audio-16khz-64kbitrate-mono-mp3
			audio file and saving it as C:\test.mp3.
	
	#>
	[OutputType('System.IO.FileInfo')]
	[CmdletBinding(DefaultParameterSetName = 'StandardVoice')]
	param
	(
		[Parameter(Mandatory, ParameterSetName = 'StandardVoice')]
		[Parameter(Mandatory, ParameterSetName = 'CustomVoice')]
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

		[Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'CustomVoice')]
		[ValidateNotNullOrEmpty()]
		[Alias('Uri')]
		[uri]$CustomEndpointUri,

		[Parameter(Mandatory, ParameterSetName = 'SSML')]
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
		'Headers'     = @{'X-Microsoft-OutputFormat' = $AudioOutput }
		'Body'        = $SSML
		'Method'      = 'POST'
		'ContentType' = 'application/ssml+xml'
		'OutFile'     = $OutputFile
		'Uri'         = "https://$($script:config.SubscriptionRegion).tts.speech.microsoft.com/cognitiveservices/v1"
	}
	if ($PSBoundParameters.ContainsKey('CustomEndpointUri')) {
		$params.Uri = $CustomEndpointUri
	}
	$null = InvokeApi @params

	if ($PassThru.IsPresent) {
		Get-Item -Path $OutputFile
	}
}