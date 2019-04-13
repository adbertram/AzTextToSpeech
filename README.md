# AzTextToSpeech

AzTextToSpeech is a PowerShell module created to work with the Azure Cognitive Services (Speech Services) Text-to-Speech API. It was built to help users more easily manage and test their text-to-speech ecosystem.

This module will help you collect up your training data using `New-TrainingDataPackage`, build transcritpts with `New-Transcript`, organize your custom endpoints and provide a way to quickly test your models using the `ConvertTo-Speech` function.

## Requirements

1. An Azure Cognitive Services account. [Link with instructions](https://docs.microsoft.com/en-us/azure/cognitive-services/cognitive-services-apis-create-account)
2. Authenticated to Azure in your PowerShell session (Connect-AzAccount)

## Getting Started

### Setting up Configuration Values

All configuration you need to do ahead and time is located in the configuration.json file. You will need to set:

 - Token endpoint. The token endpoint will be the same as what comes default but you will simply need to replace the region. https://<REGIONHERE>.api.cognitive.microsoft.com/sts/v1.0/issuetoken. This is the same region as your Azure subscription.
 - The subscription region
 - Your Cogntive Services account name and resource group
  
```JSON
{
    "TokenEndpoint": "https://<SUBSCRIPTIONREGIONHERE>.api.cognitive.microsoft.com/sts/v1.0/issuetoken",
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

You'll need a token to authenticate to Azure and AzSpeecToText has made it easy. Simply run `Connect-AzSpeechToText` after the module is imported. This will use values in your configuration.json file and issue a token saving in the module scope to be reused. Tokens are only good for 10 minutes but the module has retry capabilities built in if it fails due to a token expiration issue. If so, it will automatically get another token for you.

## Building Training Data

The text-to-speech API requireas data to be in a specific format. You need WAV files in a specific order with a specifically formatted transcript no larger than 200MB which AzSpeechToText calls a training data package.

##TODO
