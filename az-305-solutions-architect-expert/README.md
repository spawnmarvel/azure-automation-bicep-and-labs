# az-305 Microsoft Certified: Azure Solutions Architect Expert

https://learn.microsoft.com/en-us/credentials/certifications/azure-solutions-architect/

## Study guide for Exam AZ-305: Designing Microsoft Azure Infrastructure Solutions


Weight

* Design identity, governance, and monitoring solutions (25–30%)
* Design data storage solutions (20–25%)
* Design business continuity solutions (15–20%)
* Design infrastructure solutions (30–35%)

https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-305

## Practice test

https://learn.microsoft.com/en-us/credentials/certifications/practice-assessments-for-microsoft-certifications

Score

- 76%
- 
- 

## Gemini advice

To prepare for AZ-305 after AZ-104, ***you need to shift from "How do I click the buttons?" to "Which service is the best fit for this business requirement?"***

Since you've already mastered the administration side, about 40-50% of the technical knowledge is already in your head. Your focus should be on the gaps—primarily deep-dive data solutions and high-level design frameworks.

1. The "Architect Mindset" (New Frameworks)
In AZ-104, you learned how to fix things. In AZ-305, you need to learn how to plan them according to Microsoft’s gold standards.

* The Well-Architected Framework (WAF): You must memorize the 5 pillars: Cost Optimization, Operational Excellence, Performance Efficiency, Reliability, and Security.
* Cloud Adoption Framework (CAF): Understand the high-level stages: Strategy, Plan, Ready, Adopt.
* Decision Criteria: Expect questions like "You need the cheapest option that still provides 99.9% uptime." You need to know the SLAs (Service Level Agreements) for different tiers.

2. Data Storage & SQL (The Biggest Gap)
AZ-104 barely touches on databases, but AZ-305 goes deep. This is often the hardest part for administrators.

* SQL vs. NoSQL: Know when to pick Azure SQL (relational) vs. Cosmos DB (non-relational/global scale).
* Cosmos DB APIs: Understand which API to use (SQL, MongoDB, Cassandra, Gremlin, Table) based on the existing data format.
* Database Tiers: Know the difference between General Purpose, Business Critical, and Hyperscale.
* Storage Access: Deep dive into Data Lake Storage Gen2 vs. standard Blob storage for big data workloads.

3. Business Continuity (DR & High Availability)
While you know what a backup is, you now need to design the strategy.

* RTO vs. RPO: Be able to calculate Recovery Time Objective (how fast you recover) and Recovery Point Objective (how much data you can lose).
* Site Recovery (ASR): Design cross-region failover for VMs and SQL databases.
* Redundancy Levels: LRS vs. ZRS vs. GRS. You need to know exactly which one to recommend for a specific cost/availability balance.

4. Advanced Networking & App Architecture
Move beyond simple VNETs and Peering.

* Load Balancing Logic: You must know when to use:
* Front Door: Global, Layer 7 (HTTP/S).
* Traffic Manager: Global, DNS-based.
* Application Gateway: Regional, Layer 7 (WAF features).
* Azure Load Balancer: Regional, Layer 4 (Fast/Non-HTTP).
* Messaging: Understand the "Why" for Service Bus (reliable queues), Event Grid (event-driven), and Event Hubs (big data streaming).

![focus](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-305-solutions-architect-expert/images/focus.png)


## AZ-305 Microsoft Azure Architect Design Prerequisites

Describe the core architectural components of Azure

* Repeat from az-104, maybe brush later.

Describe Azure compute and networking services

* Repeat from az-104, maybe brush later.

Describe Azure storage services

* Repeat from az-104, maybe brush later.

Describe Azure identity, access, and security

* Maybe brush later.


### Introduction to the Microsoft Cloud Adoption Framework

The Cloud Adoption Framework includes eight methodologies:

1. Strategy, a guide and 5 steps. And Cloud Adoption Strategy Evaluator online tool.
2. Plan, prepare, people, discover your workload, select migration, assess, tco, azure calculator
3. Ready, the links for what to first setup, what models to set up and more, ref cloud adoption framework
4. Migrate, plan, prepare, execute, optimize, decommission
5. Innovate, plan modernize, prepare, skills and tools, execute modernize, optimize, cloud-native
6. Govern, build team, assess risk, policy, monitor (repeat)
7. Manage, responsibility, scope, secure, cost, 
8. Secure, Cloud Adoption Framwork Secure methodology, Well-Architected Framwork security guidance, Microsoft cloud security benchmark, Zero Trust guidance, 
CIA Triad model (confidentiality, integrity, avaliability) fundamental model in information security.

Strategy

![strategy](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-305-solutions-architect-expert/images/strategy.png)

A cloud adoption strategy is a comprehensive plan that outlines your organization's approach when you adopt and integrate cloud technologies.

* https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/strategy/

Cloud Adoption Strategy Evaluator

* https://learn.microsoft.com/en-us/assessments/8fefc6d5-97ac-42b3-8e97-d82701e55bab/

Ready (it seems like everything is in the cloud adoption framwork)

Ready your Azure environment for workloads

* https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/

![ready](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-305-solutions-architect-expert/images/ready.png)

Implement these elements to create a strong foundation for cloud adoption. The Azure setup guide offers step-by-step instructions to help you organize resources, control costs, and secure your environment before you deploy solutions.

* https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-setup-guide/identity

![setup](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-305-solutions-architect-expert/images/setup.png)

Define a cloud operating model

* https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/plan/prepare-organization-for-cloud#choose-a-cloud-operating-model


Govern

![govern](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-305-solutions-architect-expert/images/govern.png)


### Introduction to the Microsoft Azure Well-Architected Framework

The Azure Well-Architected Framework consists of five pillars

* Reliability, to enhance workload resilience and recoverability
* Security, to improve security by using the CIA Traid and Zero Trus princicples
* Cost Optimization, to evaluate ROI and financial constraints
* Operational Excellence, to ensure workload quality through standardized workflows
* Performance Efficency, to optimize your workloads ability to adjust to changes in demand

The Security pillar focuses on ensuring that workloads are resilient to attacks by incorporating confidentiality, integrity, availability (the CIA Triad), and Zero Trust principles.

The Cost Optimization pillar focuses on evaluating ROI and financial constraints to help allocate budgets, define spending patterns, and maximize resource investments.

The Operational Excellence pillar focuses on DevOps practices and standardized workflows to help ensure workload quality, minimize process variance, and reduce human error.

The Performance Efficiency pillar focuses on ensuring that workloads can scale efficiently based on demand to maintain performance without compromising user experience.

![5 pillar](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-305-solutions-architect-expert/images/5pillar.png)

https://learn.microsoft.com/en-us/training/paths/microsoft-azure-architect-design-prerequisites/


## AZ-305 Designing Microsoft Azure Infrastructure Solutions Study Cram - Over 100,000 views

https://www.youtube.com/watch?v=vq9LuCM4YP4

## Excel study guide check always c:\github2026\az-305-study-guide


## AZ-305: Design identity, governance, and monitor solutions

## Design governance

https://learn.microsoft.com/en-us/credentials/certifications/exams/az-305/?source=learn




