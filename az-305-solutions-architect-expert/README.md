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

https://learn.microsoft.com/en-us/training/paths/microsoft-azure-architect-design-prerequisites/




