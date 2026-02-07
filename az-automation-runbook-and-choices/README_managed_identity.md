# Managed identities for Azure resources


What are managed identities?

At a high level, there are two types of identities: human and machine/non-human identities. Machine / non-human identities consist of device and workload identities. In Microsoft Entra, workload identities are applications, service principals, and managed identities.

System-assigned. Some Azure resources, such as virtual machines allow you to enable a managed identity directly on the resource. When you enable a system-assigned managed identity:

* A service principal of a special type is created in Microsoft Entra ID for the identity. The service principal is tied to the lifecycle of that Azure resource. When the Azure resource is deleted, Azure automatically deletes the service principal for you.

User-assigned. You may also create a managed identity as a standalone Azure resource. You can create a user-assigned managed identity and assign it to one or more Azure Resources. When you enable a user-assigned managed identity:

* A service principal of a special type is created in Microsoft Entra ID for the identity. The service principal is managed separately from the resources that use it.

https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/


## Differences between system-assigned and user-assigned managed identities

## Use in script

