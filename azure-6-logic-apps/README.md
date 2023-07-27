## Logic app


## Done it with Python Function and HTTP connector for logic app

https://follow-e-lo.com/

Search for it

## MS learn Logic Apps

* A business process or workflow is a sequence of tasks that produce a specific outcome.
* Azure Logic Apps is a cloud service that automates the execution of your business processes.
* The components let you connect to hundreds of external services.
* The goal of Azure Logic Apps in one word, we'd choose integration. 

How Azure Logic Apps works
* A connector is a component that provides an interface to an external service. 
* Workflows are built from different types of tasks. 
* Azure Logic Apps uses the terms trigger, action, and control action for these concepts. These operations are the building blocks of Azure Logic Apps.

![Learn logic app ](https://github.com/spawnmarvel/azure-automation/tree/main/eventhub/images/learnlogicapp.jpg)

A trigger is an event that occurs when a specific set of conditions is satisfied. Triggers activate automatically when conditions are met. For example, when a timer expires or data becomes available.

An action is an operation that executes a task in your business process. Actions run when a trigger activates or another action completes.

Control actions are special actions built-in to Azure Logic Apps that provides these control constructs:

* Condition statements controlled by a Boolean expression.
* Switch statements.
* For each and until loops.
* Unconditional branch instructions.

### When to use Azure Logic Apps

Decision criteria
* The cases where Azure Logic Apps might not be the best option typically involve real-time requirements, complex business rules, or use of nonstandard services. Here's some discussion of each of these factors.

| Factor      | Description                                            | Note
| ----------- | ------------------------------------------------------ | ---- 
| Integration | Azure Logic Apps works well when you need to get multiple applications and systems to work together. That's what they were designed to do. | If you're building an app with no external connections, Azure Logic Apps is probably not the best option.
| Performance | Execution engine scales your apps automatically. Azure Logic Apps can process large data-sets in parallel to let you achieve high throughput. However, they don't guarantee super-fast activation or enforce real-time constraints on execution time. | If you're looking for low subsecond response time, then Azure Logic Apps may not be the best fit.
| Conditionals | Azure Logic Apps provides control constructs like Boolean expressions, switch statements, and loops so your apps can make decisions based on your data. | There are two reasons you might prefer not to. First, it's often easier to write conditional logic in code rather than using the workflow designer. Second, embedded business rules aren't easily sharable with your other apps. 
| Connectors | Is whether there are prebuilt connectors for all the services you need to access.| If so, then you're ready to go. 

Guidance summary

![Learn logic app guide ](https://github.com/spawnmarvel/azure-automation/tree/main/eventhub/images/logicappguide.jpg)

https://learn.microsoft.com/en-us/training/modules/intro-to-logic-apps/1-introduction

### Logic Apps Standard Performance Benchmark - Burst workloads

Execution Elapsed Time

The chart below represents the total time take to process a batch of 40k and 100k messages, respectively, when using a WS1, WS2 and WS3 app service plan:

![Benchmark ](https://github.com/spawnmarvel/azure-automation/blob/main/images/benchmark.jpg)
              

https://techcommunity.microsoft.com/t5/azure-integration-services-blog/logic-apps-standard-performance-benchmark-burst-workloads/ba-p/3317930
