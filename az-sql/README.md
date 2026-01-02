# Deploy Azure SQL Database for free

For each database, you receive a monthly allowance of 100,000 vCore seconds of compute, 32 GB of data storage, and 32 GB of backup storage, free for the lifetime of your subscription.


* Use the Azure portal to create the new free Azure SQL Database.
* [...]
* If you choose Auto-pause the database until next month option, you'll not be charged for that month once the free limits are reached, however the database will become inaccessible for the remainder of the calendar month.


Here is the db

![db](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-sql/images/sqldb.png)

Here is the fields for keeping it free

![billing](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-sql/images/billing.png)

https://learn.microsoft.com/en-us/azure/azure-sql/database/free-offer?view=azuresql

## Conect to db

There are many ways here we use the new MSSM.

Remember to update networking with your new public ip, it changes.

![connect](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-sql/images/connect.png)

Then we are connected

![connected](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-sql/images/connected.png)

## Restore db for querys

Load Sample Database

https://www.sqlservertutorial.net/getting-started/load-sample-database/


https://github.com/spawnmarvel/t-sql






