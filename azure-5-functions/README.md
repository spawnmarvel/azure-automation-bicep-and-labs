## Functions


### Done it with Python

https://follow-e-lo.com/

Search for it

### Azure Functions documentation

https://learn.microsoft.com/en-us/azure/azure-functions/


### Create a function in the portal


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

Create an HTTP-triggered function
* From the left menu of the Functions window, select Functions.
* Select Add from the top menu and enter the following values.
* Setting	Value	Remarks
* Development environment	Develop in portal	
* Template	HTTP Trigger	
* New Function	name. This is the name of your function.
* Authorization level	Function	

Select the Add button.
* Select the Code + Test button.
* Paste the your code in the code editor window.

![Function ](https://github.com/spawnmarvel/azure-automation/blob/main/images/function.jpg)


https://learn.microsoft.com/en-us/azure/azure-functions/functions-twitter-email




