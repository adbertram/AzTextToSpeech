@{
	RootModule        = 'AzSpeechToText.psm1'
	ModuleVersion     = '*'
	GUID              = 'b375c986-205d-4759-a4cb-3180dc073a64'
	Author            = 'Adam Bertram'
	CompanyName       = 'Adam the Automator, LLC'
	Copyright         = '(c) 2019 Adam the Automator, LLC. All rights reserved.'
	Description       = 'A PowerShell module to work with the Azure Speech Services text to speech API'
	RequiredModules   = 'Az.CognitiveServices'
	FunctionsToExport = '*'
	VariablesToExport = '*'
	AliasesToExport   = '*'
	PrivateData       = @{
		PSData = @{
			Tags       = @('AzureCognitiveServices', 'Blogs')
			ProjectUri = 'https://github.com/adbertram/AzSpeechToText'
		}
	}
}