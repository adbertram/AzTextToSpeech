# AzTextToSpeech

[![Build status](https://ci.appveyor.com/api/projects/status/7533b87cmwl8bluw?svg=true)](https://ci.appveyor.com/project/adbertram/aztexttospeech)

AzTextToSpeech is a PowerShell module created to work with the Azure Cognitive Services (Speech Services) Text-to-Speech API. It was built to help users more easily manage and test their text-to-speech ecosystem.

This module will help you collect up your training data using `New-TrainingDataPackage`, build transcripts with `New-Transcript`, quickly retrieve your custom endpoints and provide a way to quickly test SSML using the `ConvertTo-Speech` function.

## Requirements

There are two ways you can use this module. You can either sign up for a free trial key [here](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/get-started) or you can use an Azure Cognitive Services account which requires an Azure account.

If you're just using the free trial API key, you will need:

1. Your API Key
2. The Az.CognitiveServices PowerShell module

If you are already have an Azure account and are not using the free trial key, you will need:

1. An Azure Cognitive Services account. [Link with instructions](https://docs.microsoft.com/en-us/azure/cognitive-services/cognitive-services-apis-create-account)
2. Authenticated to Azure in your PowerShell session (Connect-AzAccount)
3. The Az.CognitiveServices PowerShell module

## Getting Started

### Setting up Configuration Values

All configuration you need to do ahead and time is located in the configuration.json file. 

#### Free Trial Key

If you are not using an Azure Cognitive Services account, you will need to set the following configuration values in configuration.json:

 - Token endpoint. The token endpoint will be always be https://westus.api.cognitive.microsoft.com/sts/v1.0/issuetoken.
 - The subscription region which will always be westus.

 You will then need to save your API key encrypted in configuration.json. To do that, run `Save-ApiKey -Key <YourKeyHere>`. This will encrypt and save the key for use by the module later.

#### Cognitive Services Account

If you are using an Azure Cognitive Services account, you will need to set the following configuration values in configuration.json:

 - Token endpoint. The token endpoint will be the same as what comes default but you will simply need to replace the region. https://REGIONHERE.api.cognitive.microsoft.com/sts/v1.0/issuetoken. This is the same region as your Azure subscription.
 - The subscription region
 - Your Cognitive Services account name and resource group
 
 You can find the token endpoint, subscription region and account information by running `Get-AzCognitiveServicesAccount | Select-Object -Property Endpoint,AccountName,ResourceGroupName,Location`.
  
```JSON
{
    "TokenEndpoint": "https://<SUBSCRIPTIONREGIONHERE>.api.cognitive.microsoft.com/sts/v1.0/issuetoken",
    "APIKey": "",
    "CustomEndpoints": [{
        "Name": "",
        "Uri": ""
    }],
    "SubscriptionRegion": "",
    "CognitiveServicesAccount": {
        "Name": "",
        "ResourceGroupName": ""
    }
}
```

### Grabbing your first token

You'll need a token to authenticate to Azure and AzTextToSpeech has made it easy. Simply run `Connect-AzTextToSpeech` after the module is imported. This will use values in your configuration.json file and issue a token saving in the module scope to be reused. Tokens are only good for 10 minutes but the module has retry capabilities built in if it fails due to a token expiration issue. If so, it will automatically get another token for you.

## Building Training Data

The text-to-speech API requires data to be in a specific format. You need WAV files in a specific order with a specifically formatted transcript no larger than 200MB which AzTextToSpeech calls a training data package.

##TODO
