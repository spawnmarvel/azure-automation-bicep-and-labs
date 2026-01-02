# Azure Functions

## Docs

https://learn.microsoft.com/en-us/azure/azure-functions/

## Ms Learn 28 results for "azure functions" (do them all)

https://learn.microsoft.com/en-us/training/browse/?terms=azure%20functions&source=learn

There is also something on e-lo, 5 min Azure Functions compute with powershell 3 steps (az login) publish* https://follow-e-lo.com/2023/01/22/todo-5-min-azure-functions-compute-3/

### 1 Develop Azure Functions

https://learn.microsoft.com/en-us/training/modules/develop-azure-functions/

### Azure Functions scenarios

* Run code when a file is uploaded or changed in blob storage.
* Execute data clean-up code on predefined timed intervals.
* Run custom logic when a document is created or updated in a database.

https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview

## Powershell function

Lets create apowershell function with the new plan that takes over for consumption, Flex consumption.

Lets use it to extract resource data for vm's and more using az powershell module.

1. Create a resource group
2. Create a storage account (or do it in the function app create)
3. Create the function app and map it to the storage account

* Storage v2, funappgetresources01
* Function App with core powershell 7.4, funappgetresourcesapp01


![fun app](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-functions/images/fun_app.png)

### Create function, test, publish and republish with VS Code Desktop

* Install Azure Functions extension. You can also install the Azure Tools extension pack, which is recommended for working with Azure resources.
* and some more

You can now deploy a code project to the function app resources you created in Azure.


1. Create the local code project
2. Verify locally
3. Publish to Azure

1. Open just the terminal in VSC

```ps1
# Check environment, after all prerequisites is installed.
func --version
4.0.4915

(Get-Module -ListAvailable Az).Version
Major  Minor  Build  Revision
-----  -----  -----  --------
9      1      1      -1

connect-AzAccount -TenantId XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
# Authentication complete. You can return to the application. Feel free to close this browser tab.
```
Create a local function project and choose powershell

```ps1
mkdir funappgetresourcesapp01folder
cd .\funappgetresourcesapp01folder

func init funappgetresourcesapp01Project
Use the up/down arrow keys to select a worker runtime:
dotnet
dotnet (isolated process)
node
python
powershell
custom

```
This folder contains various files for the project, including configuration files named local.settings.json and host.json. Because local.settings.json can contain secrets downloaded from Azure, the file is excluded from source control by default in the .gitignore file.

List function templates

```ps1
func templates list -l powershell
PowerShell Templates:
  Azure Blob Storage trigger
  Azure Cosmos DB trigger
  Durable Functions activity
  Durable Functions HTTP starter
  Durable Functions orchestrator
  Azure Event Grid trigger
  Azure Event Hub trigger
  HTTP trigger
  IoT Hub (Event Hub)
  Kafka output
  Kafka trigger
  Azure Queue Storage trigger
  RabbitMQ trigger
  SendGrid
  Azure Service Bus Queue trigger
  Azure Service Bus Topic trigger
  SignalR negotiate HTTP trigger
  Timer trigger

```

Lest create a http trigger for powershell https://learn.microsoft.com/en-us/azure/azure-functions/functions-bindings-http-webhook-trigger?tabs=python-v2%2Cisolated-process%2Cnodejs-v4%2Cfunctionsv2&pivots=programming-language-powershell

The http trigger is create, it will trigger every time we vist the url. So we could set it up with logical app to run on a schedule and perform other task as well.

```ps1
func new --name funappgetresourcesapp01 --template "HTTP trigger" --authlevel "anonymous"
# Select powershell as run time
# The function "funappgetresourcesapp01" was created successfully from the "HTTP trigger" template.
```
* function.json
function.json is a configuration file that defines the input and output bindings for the function, including the trigger type.
* 
run.ps1 is the code

Run.ps1 default code

```ps1
using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
$name = $Request.Query.Name
if (-not $name) {
    $name = $Request.Body.Name
}

$body = "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response."

if ($name) {
    $body = "Hello, $name. This HTTP triggered function executed successfully."
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})

```

Now start the function with the default template

```ps1
func start
# Ctrl+c for quit

```
![function app started ](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-functions/images/fun_start.png)

https://learn.microsoft.com/en-us/azure/azure-functions/functions-create-function-app-portal?tabs=vs-code&pivots=flex-consumption-planan

Full docs

https://learn.microsoft.com/en-us/azure/azure-functions/functions-develop-vs-code?tabs=node-v4%2Cpython-v2%2Cisolated-process%2Cquick-create&pivots=programming-language-powershell


### Publish powershell function

Lets say we happy with the current function, we can then publish it.

Before you can deploy your function code to Azure, you need to create three resources:

* A resource group, which is a logical container for related resources.
* A storage account, which maintains the state and other information about your projects.
* A function app, which provides the environment for executing your function code. A function app maps to your local function project and lets you group functions as a logical unit for easier management, deployment, and sharing of resources.

So we now depoloy the local function to Azure using the same function name.


```ps1
# Assuming connect-AzAccount -TenantId XXXXXXX is success
func azure functionapp publish funappgetresourcesapp01
```






