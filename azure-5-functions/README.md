## Functions

### Azure Functions documentation

https://learn.microsoft.com/en-us/azure/azure-functions/


#### 5. Azure functions (alternative to Automation Account, why use Automation, functions are more for dev, but not necessarily infrastructure, but processing data)

Azure Functions is a serverless solution that allows you to write less code, maintain less infrastructure, and save on costs.

| If you want to | Then...
| -------------- | -------
| Build a web API |	Implement an endpoint for your web applications using the HTTP trigger
| Process file uploads |	Run code when a file is uploaded or changed in blob storage
| Build a serverless workflow |	Create an event-driven workflow from a series of functions using durable functions
| Respond to database changes |	Run custom logic when a document is created or updated in Azure Cosmos DB
| Run scheduled tasks |	Execute code on pre-defined timed intervals
| Create reliable message queue systems |	Process message queues using Queue Storage, Service Bus, or Event Hubs
| Analyze IoT data streams |	Collect and process data from IoT devices
| Process data in real time	| Use Functions and SignalR to respond to data in the moment
| Connect to a SQL database	| Use SQL bindings to read or write data from Azure SQL

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


### Create a function in Powershell in with Bicep

You only need to specify rg and location the rest of the parameters and vars will always be unique to the rg in main.bicep.
```
# rg and location
$rgName = "Rg-iac-0052"
$location  = "uk south"

```
Deploy it with the deploy.ps1 that uses the main.bicep

![Extra function deploy ](https://github.com/spawnmarvel/azure-automation/blob/main/images/extra_function_deploy.jpg)

Deployed to Azure

```
// Microsoft.Storage/storageAccounts: create an Azure Storage account, which is required by Functions.
// Microsoft.Web/serverfarms: create a serverless Consumption hosting plan for the function app.
// Microsoft.Web/sites: create a function app.
// microsoft.insights/components: create an Application Insights instance for monitoring.

```
![Extra function resources ](https://github.com/spawnmarvel/azure-automation/blob/main/images/extra_function_resources.jpg)

Now you can create a function in Powershell (default), edit runtime for Python function

```
@description('The language worker runtime to load in the function app.')
@allowed([
  'powershell'
  'python'
])
param runtime string = 'powershell'
```

Make a function

![Extra function create ](https://github.com/spawnmarvel/azure-automation/blob/main/images/extra_function_create.jpg)

Test default boiler (NB: Authorization level = App Key)

![Extra function boiler ](https://github.com/spawnmarvel/azure-automation/blob/main/images/extra_function_boiler.jpg)

Example function app URL default
* https://fnappk5ifnn2azmpow.azurewebsites.net/

![Extra function main ](https://github.com/spawnmarvel/azure-automation/blob/main/images/extra_function_main.jpg)

Press Test/Run or Get Function URL

![Extra function test ](https://github.com/spawnmarvel/azure-automation/blob/main/images/extra_function_test.jpg)

Example default function URL
* * https://fnappk5ifnn2azmpow.azurewebsites.net/api/HttpTrigger1?code=APPKEY==

![Extra function main sub ](https://github.com/spawnmarvel/azure-automation/blob/main/images/extra_function_main_sub.jpg)

For function URL with param
* * https://fnappk5ifnn2azmpow.azurewebsites.net/api/HttpTrigger1?name=John&code=APP-KEY==

![Extra function param john ](https://github.com/spawnmarvel/azure-automation/blob/main/images/extra_function_john.jpg)

You can host multiple functions in one function app

![Extra function multiple ](https://github.com/spawnmarvel/azure-automation/blob/main/images/extra_function_multiple.jpg)


https://learn.microsoft.com/en-us/azure/azure-functions/functions-create-first-function-bicep



### Create a Consumption plan

* A Consumption plan doesn't need to be defined. When not defined, a plan is automatically be created or selected on a per-region basis when you create the function app resource itself.
* The Consumption plan is a special type of serverfarm resource. You can specify it by using the Dynamic value for the computeMode and sku properties.
* Windows
* Linux, The function app must have set "kind": "functionapp,linux", and it must have set property "reserved": true. Linux apps should also include a linuxFxVersion property under siteConfig. 


https://learn.microsoft.com/en-us/azure/azure-functions/functions-infrastructure-as-code?tabs=bicep#consumption

For a sample Bicep file/Azure Resource Manager template, see:
https://github.com/Azure-Samples/function-app-arm-templates/blob/main/function-app-linux-consumption/main.bicep


### How-to-guides


Continuous deployment for Azure Functions

https://learn.microsoft.com/en-us/azure/azure-functions/functions-continuous-deployment

Azure Functions deployment slots

https://learn.microsoft.com/en-us/azure/azure-functions/functions-deployment-slots

Continuous delivery by using GitHub Actions

https://learn.microsoft.com/en-us/azure/azure-functions/functions-how-to-github-actions?tabs=dotnet