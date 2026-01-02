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

### Powershell function

Lets create apowershell function with the new plan that takes over for consumption, Flex consumption.

Lets use it to extract resource data for vm's and more using az powershell module.

1. Create a resource group
2. Create a storage account (or do it in the function app create)
3. Create the function app and map it to the storage account

* Storage v2, funappgetresources01
* Function App with core powershell 7.4


![fun app](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-functions/images/fun_app.png)

### Create function, test, publish and republish with VS Code Desktop

* Install Azure Functions extension. You can also install the Azure Tools extension pack, which is recommended for working with Azure resources.
* and some more

You can now deploy a code project to the function app resources you created in Azure.


1. Create the local code project
2. Verify locally
3. Publish to Azure

https://learn.microsoft.com/en-us/azure/azure-functions/functions-create-function-app-portal?tabs=vs-code&pivots=flex-consumption-planan

Full docs

https://learn.microsoft.com/en-us/azure/azure-functions/functions-develop-vs-code?tabs=node-v4%2Cpython-v2%2Cisolated-process%2Cquick-create&pivots=programming-language-powershell








