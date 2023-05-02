## Functions

### Azure Functions documentation

https://learn.microsoft.com/en-us/azure/azure-functions/

### Create function in Python from VSC

https://follow-e-lo.com/

Search for it on e-lo

### Create a function in Powershell in the portal

Create the function app
* From the top search box, search for and select Function app.
* Select Create.
* Enter the following values.

* Setting	Suggested Value	Remarks
* Subscription	Your Azure subscription name	
* Resource group	tweet-sentiment-tutorial	Use the same resource group name throughout this tutorial.
* Function App name	TweetSentimentAPI + a unique suffix	Function application names are globally unique. Valid characters are a-z (case insensitive), 0-9, and -.
* Publish	Code	
* Runtime stack Powershell	
* Version	Select the latest version number	
* Region	Select the region closest to you	
* Select Review + create.

* Select Create.

Once the deployment is complete, select Go to Resource.

https://test0041.azurewebsites.net/

Create an HTTP-triggered function
* From the left menu of the Functions window, select Functions.
* Select Add from the top menu and enter the following values.
* Setting	Value	Remarks
* Development environment	Develop in portal	
* Template	HTTP Trigger	
* New Function	name. This is the name of your function.
* Authorization level	Function	

![Function ](https://github.com/spawnmarvel/azure-automation/blob/main/images/function.jpg)

Select the Add button.
* Select the Code + Test button.
* Paste the your code in the code editor window.
* Or edit the boiler code

![Function code ](https://github.com/spawnmarvel/azure-automation/blob/main/images/function2.jpg)


Visit the app

![Function app ](https://github.com/spawnmarvel/azure-automation/blob/main/images/function_app.jpg)

Visit the function (since Authorization level Function, you must have Function keys )

![Function http ](https://github.com/spawnmarvel/azure-automation/blob/main/images/function_http.jpg)

With key (read about access level below)

![Function http key ](https://github.com/spawnmarvel/azure-automation/blob/main/images/function_http_key.jpg)



https://learn.microsoft.com/en-us/azure/azure-functions/functions-twitter-email

### Azure Functions HTTP trigger Authorization level

Determines what keys, if any, need to be present on the request in order to invoke the function. For supported values, see Authorization level.

https://learn.microsoft.com/en-us/azure/azure-functions/functions-bindings-http-webhook-trigger?pivots=programming-language-powershell

Authorization level
* anonymous	No API key is required.
* function	A function-specific API key is required. This is the default value when a level isn't specifically set.
* admin	The master key is required.

Authorization scopes (function-level)
* Function: These keys apply only to the specific functions under which they're defined. When used as an API key, these only allow access to that function.
* Host: Keys with a host scope can be used to access all functions within the function app. When used as an API key, these allow access to any function within the function app.
 
Obtaining keys
* Keys are stored as part of your function app in Azure and are encrypted at rest. 
* To view your keys, create new ones, or roll keys to new values, navigate to one of your HTTP-triggered functions in the Azure portal and select Function Keys.

![Function keys ](https://github.com/spawnmarvel/azure-automation/blob/main/images/function_keys.jpg)

https://learn.microsoft.com/en-us/azure/azure-functions/functions-bindings-http-webhook-trigger?pivots=programming-language-powershell#http-auth




