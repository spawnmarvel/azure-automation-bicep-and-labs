# Microsoft Applied Skills: Administrer Active Directory Domain Services

https://learn.microsoft.com/nb-no/credentials/applied-skills/administer-active-directory-domain-services/


# Active Directory Applied Skills Assessment - Summary & Solution Guide

This document provides a complete overview of the tasks completed during the Microsoft Applied Skills assessment for Active Directory Domain Services (AD DS), detailing **what** was configured, **why** it was necessary, and **how** each step was executed.

---

## Table of Contents
1. Multi-Site Infrastructure & Domain Controller Deployment
2. Organizational Unit, Delegation, & Security Accounts
3. Account Migration & User Lifecycle Management
4. Fine-Grained Password Policies & Active Directory Recycle Bin
5. Domain & Branch Group Policy Enforcement
6. Summary Result

---

## 1. Multi-Site Infrastructure & Domain Controller Deployment

### What Was Done
* Created a new Active Directory site named **Paris** and associated the subnet `172.16.1.0/24` with it.
* Promoted **DC2** to an additional Domain Controller for the `contoso.com` domain within the **Paris** site using DSRM password `Pa55w.rd`.
* Transferred the **RID Operations Master (FSMO)** role from DC1 to DC2.

### Why It Was Done
* **Site & Subnet Association:** Ensures client authentication and replication traffic in the Paris branch office are optimized locally based on IP network topology.
* **Additional DC:** Provides redundancy, fault tolerance, and localized authentication services for users in the new branch location.
* **RID Master Transfer:** Balances FSMO role responsibilities and ensures DC2 can directly manage Relative Identifier allocations for newly created security principals.

### How It Was Done
1. **Site & Subnet Creation:**
   * Opened `dssite.msc` (Active Directory Sites and Services).
   * Created a new site named **Paris** and linked it to `DEFAULTIPSITELINK`.
   * Under **Subnets**, added `172.16.1.0/24` and assigned it to the **Paris** site.

2. **Domain Controller Promotion:**
   * Installed the **AD DS** role on **DC2**.
   * Promoted DC2 to a Domain Controller in `contoso.com`, assigning it to the **Paris** site with the required DSRM password (`Pa55w.rd`).

3. **FSMO Role Transfer:**
   * Opened Active Directory Users and Computers (`dsa.msc`), connected to **DC2**, right-clicked `contoso.com` -> **Operations Masters...** -> **RID** tab, and executed the role transfer.

---

## 2. Organizational Unit, Delegation, & Security Accounts

### What Was Done
* Created an Organizational Unit (OU) named **Paris**.
* Created a Universal Security Group named **Paris Admins** within the Paris OU.
* Created a temporary user account named **ParisContractor** with:
  * Expiration date set to **December 31, 2027**.
  * Membership in **Paris Admins** and **Protected Users**.
* Delegated password reset permissions over the Paris OU exclusively to the **Paris Admins** group.

### Why It Was Done
* **Structure & Scope:** Organizes branch objects into a dedicated container for targeted administration and policy application.
* **Security & Least Privilege:** Limits Paris Admins to password management tasks within their own OU rather than granting broad administrative rights across the domain.
* **Protected Users Group:** Enhances security for administrative and temporary accounts by restricting weak authentication protocols (NTLM, DES, Digest) and credential caching in LSASS.

### How It Was Done
1. **OU & Objects Creation:**
   * Created the `Paris` OU under the domain root.
   * Inside `Paris`, created the **Paris Admins** Universal Security Group and the **ParisContractor** user account.

2. **User Configuration:**
   * Modified **ParisContractor** properties -> **Account** tab -> Set expiration to **December 31, 2027**.
   * Added **ParisContractor** to the **Paris Admins** and **Protected Users** groups via the **Member Of** tab.

3. **Permission Delegation:**
   * Right-clicked the **Paris** OU -> **Delegate Control...** -> Added **Paris Admins** -> Granted **Reset user passwords and force password change at next logon**.

---

## 3. Account Migration & User Lifecycle Management

### What Was Done
* Located all user accounts with the `City` attribute set to `Paris`.
* Moved these user accounts to the **Paris** OU.
* Configured all moved user accounts to be **disabled** and **forced to change password at next logon**.

### Why It Was Done
* **Standardization:** Aligns user account placement with geographical location attributes for consistent GPO application.
* **Security Onboarding:** Disabling migrated accounts and requiring password updates ensures credentials are properly audited and updated before access is granted.

### How It Was Done
1. **Finding & Moving Accounts:**
   * Used **Find Users, Contacts, and Groups** -> **Advanced** tab -> Filtered by `City` starts with `Paris`.
   * Selected all 11 matching accounts, clicked **Move...**, and selected the **Paris** OU.

2. **Configuring Account Settings:**
   * Refreshed the **Paris** OU view (`F5`).
   * Selected all migrated users, right-clicked, and selected **Disable Account**.
   * Multi-selected account **Properties** -> **Account** tab -> Checked **User must change password at next logon**.

---

## 4. Fine-Grained Password Policies & Active Directory Recycle Bin

### What Was Done
* Updated the **Default Domain Policy** minimum password length to **12 characters**.
* Created a Fine-Grained Password Policy (FGPP) named **Domain Admins FGPP** requiring a minimum password length of **16 characters**, applied directly to the **Domain Admins** group.
* Enabled the **Active Directory Recycle Bin**.

### Why It Was Done
* **Enhanced Authentication Security:** Strengthens default domain password requirements while enforcing stricter standards for high-privilege administrative accounts.
* **Disaster Recovery & Reliability:** Allows rapid recovery of accidentally deleted AD objects along with their full attribute history without requiring authoritative restores from backup.

### How It Was Done
1. **Default Domain Policy Update:**
   * Opened `gpmc.msc` -> Edited **Default Domain Policy** -> **Computer Configuration** -> **Policies** -> **Windows Settings** -> **Security Settings** -> **Account Policies** -> **Password Policy** -> Set **Minimum password length** to `12`.

2. **Fine-Grained Password Policy Creation:**
   * Opened Active Directory Administrative Center (`dsac.exe`) -> **System** -> **Password Settings Container**.
   * Created a new Password Setting with **Precedence 1**, **Minimum password length 16**, and applied it directly to **Domain Admins**.

3. **Active Directory Recycle Bin:**
   * In `dsac.exe`, selected `contoso (local)` root -> Clicked **Enable Recycle Bin...** in the right Tasks pane.

---

## 5. Domain & Branch Group Policy Enforcement

### What Was Done
* Modified the **Default Domain Controllers Policy** to deny all NTLM authentication requests across the domain.
* Created a new GPO named **GPO1** and linked it to the **Paris** OU.
* Configured **GPO1** to:
  * Audit unsuccessful logon events (**Failure** auditing).
  * Prevent members of **Paris Admins** from logging on as a service on computers in the Paris OU (**Deny log on as a service**).

### Why It Was Done
* **Protocol Hardening:** Disabling NTLM prevents relay and downgrade attacks, forcing Kerberos authentication across domain controllers.
* **Audit & Compliance:** Logs failed authentication attempts on Paris branch machines for threat detection and security monitoring.
* **Least Privilege Hardening:** Blocks administrative user accounts from running background service workloads, mitigating credential exposure in memory.

### How It Was Done
1. **NTLM Restriction:**
   * Edited **Default Domain Controllers Policy** -> **Computer Configuration** -> **Policies** -> **Windows Settings** -> **Security Settings** -> **Local Policies** -> **Security Options**.
   * Set **Network security: Restrict NTLM: NTLM authentication in this domain** to **Deny all**.

2. **GPO Creation & Link:**
   * In `gpmc.msc`, right-clicked the **Paris** OU -> **Create a GPO in this domain, and Link it here...** -> Named it `GPO1`.

3. **GPO Configuration:**
   * Edited **GPO1**:
     * **Audit Policy:** **Local Policies** -> **Audit Policy** -> **Audit logon events** -> Checked **Failure**.
     * **User Rights Assignment:** **Local Policies** -> **User Rights Assignment** -> **Deny log on as a service** -> Added **Paris Admins**.

---

## 6. Summary Result

* **Score Achieved:** 100%
* **Passing Threshold:** 71%
* **Status:** Passed / Credential Awarded