# 🌐 Module: Azure Networking Topology
**Project:** eShopOnWeb Infrastructure  
**Author:** Chamseddine Boughanmi  
**Contact:** [chamseddine.boughanmi@esprit.tn](mailto:chamseddine.boughanmi@esprit.tn)

---

## 📝 Description
This module establishes the core network foundation for the eShopOnWeb environment. It creates a segmented **Virtual Network (VNet)** designed for high security and isolation, featuring dedicated subnets for the application layer, database layer, management, and private connectivity.

## 🏗️ Architecture & Topology
The network is built on the address space `10.0.0.0/16` and is divided into the following segments:

* **WebApp Subnet (`10.0.1.0/24`)**: Features delegation for Azure App Service regional VNet integration.
* **Database Subnet (`10.0.2.0/24`)**: Isolated segment with an NSG to permit only SQL traffic (1433) from the WebApp.
* **Management Subnet (`10.0.3.0/24`)**: Dedicated for DevOps agents and administrative tasks.
* **Endpoints Subnet (`10.0.4.0/24`)**: Reserved for Private Link/Private Endpoint integrations.

## 🛡️ Security Features
- **Service Endpoints**: Secured access to `Microsoft.Sql`, `Microsoft.KeyVault`, and `Microsoft.ContainerRegistry` directly via the Azure backbone.
- **Network Security Groups (NSG)**: Implements "Least Privilege" by restricting inbound DB traffic to specific internal source ranges.

## 📥 Inputs (Variables)

| Name | Type | Description |
|:---|:---:|:---|
| `resource_group_name` | `string` | The Azure Resource Group hosting the network. |
| `location` | `string` | The Azure region (e.g., West Europe). |

## 📤 Outputs

| Name | Description |
|:---|:---|
| `vnet_id` | The unique Resource ID of the Virtual Network. |
| `webapp_subnet_id` | ID for App Service VNet Integration. |
| `db_subnet_id` | ID for Database placement. |
| `mgmt_subnet_id` | ID for Management/DevOps resources. |
| `endpoint_subnet_id` | ID for Private Endpoint configurations. |

## 🚀 Usage Example

```hcl
module "networking" {
  source              = "./modules/networking"
  resource_group_name = var.rg_name
  location            = "North Europe"
}
