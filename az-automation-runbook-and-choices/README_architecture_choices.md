# Azure Automation vs. Update Manager vs. Azure Functions

This table compares the primary tools used for managing infrastructure, patching, and serverless logic within Azure.

| Feature | **Azure Automation** | **Azure Update Manager** | **Azure Functions** |
| :--- | :--- | :--- | :--- |
| **Best For** | Infrastructure scripting & complex orchestration. | OS Patching & Compliance reporting. | Event-driven code & micro-tasks. |
| **Logic Type** | **Imperative:** You script exactly *how* to do it. | **Declarative:** You define *what* status you want. | **Reactive:** Code runs in response to an event. |
| **Max Runtime** | 3 Hours (Fair share limit). | N/A (Handled as a service). | 5–10 Minutes (Consumption plan). |
| **Cost** | 500 min/month Free. | Free for Azure VMs. | 1M executions/month Free. |
| **Pros** | High control; handles long tasks; built-in scheduling. | Zero code; native compliance dashboard; no agents. | Extremely cheap; highly scalable; supports many languages. |
| **Cons** | Requires script maintenance; logs are just text. | Only for OS updates; cannot install software. | Short timeouts; requires Logic App for scheduling. |

---

### Capabilities Overview

#### ✅ What We CAN Do
* **Azure Automation:** Orchestrate "Start -> Patch -> Stop" workflows; Install custom software like **MySQL**; manage resources across multiple Resource Groups.
* **Azure Update Manager:** View a "Red/Green" compliance dashboard; schedule automatic security assessments; handle reboots intelligently.
* **Azure Functions:** Trigger a script when a file is uploaded; process data via API; run micro-tasks at massive scale.

#### ❌ What We CANNOT Do
* **Azure Automation:** Get a high-level compliance dashboard without writing custom reporting logic.
* **Azure Update Manager:** Perform non-patching tasks (cannot install apps, clear caches, or run custom CLI commands).
* **Azure Functions:** Run long-running maintenance (like a 30-minute kernel upgrade) without the script being killed by timeouts.