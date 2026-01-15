# 🚀 Module: Azure Web App (eShopOnWeb)
**Project:** eShopOnWeb Infrastructure  
**Author:** Chamseddine Boughanmi  
**Contact:** [chamseddine.boughanmi@esprit.tn](mailto:chamseddine.boughanmi@esprit.tn)

---

## 📝 Description
This module is responsible for deploying the **Azure Linux Web App** that hosts the containerized eShopOnWeb application. It acts as the integration hub, connecting the frontend to the SQL Database, Blob Storage, and Application Insights while ensuring secure networking via VNet Integration.

## 🏗️ Resources Managed
- **App Service Plan**: Linux-based compute (Basic B1 tier) to host the containers.
- **Linux Web App**: The core application service configured for Docker.
- **VNet Integration**: `Swift Connection` allowing the Web App to securely communicate with backend resources without exposing them to the public internet.
- **Managed Identity**: User-Assigned identity used for secure ACR pulls and resource access.

## ⚙️ Technical Highlights
- **Docker Orchestration**: Pulls images directly from Azure Container Registry (ACR) using Managed Identity (passwordless).
- **Dynamic Configuration**: Automatically handles `CatalogBaseUrl` trimming to ensure .NET compatibility.
- **Enhanced Networking**: Configured with `vnet_route_all_enabled` and custom DNS settings (`168.63.129.16`) to ensure stable container pulls and backend connectivity.
- **Observability**: Integrated with Application Insights for real-time telemetry and structured logging.

## 📥 Inputs (Variables)

| Name | Type | Description | Sensitive |
|:---|:---:|:---|:---:|
| `webapp_subnet_id` | `string` | The Subnet ID used for VNet integration. | No |
| `sql_server_name` | `string` | Name of the target SQL Server. | No |
| `sql_user` | `string` | SQL Administrator username. | No |
| `sql_password` | `string` | SQL Administrator password. | **Yes** |
| `acr_login_server` | `string` | URL of the Azure Container Registry. | No |
| `storage_url` | `string` | The base URL for the Blob Storage service. | No |

## 📤 Outputs

| Name | Description |
|:---|:---|
| `webapp_name` | The unique name of the Azure Web App. |
| `webapp_url` | The default hostname (e.g., `app-eshop.azurewebsites.net`). |

## 🚀 Usage Example

```hcl
module "webapp" {
  source              = "./modules/webapp"
  resource_group_name = var.rg_name
  location            = var.location
  webapp_subnet_id    = module.networking.webapp_subnet_id
  sql_server_name     = module.database.sql_server_name
  sql_user            = "sqladmin"
  sql_password        = var.db_password
  storage_url         = module.storage.primary_blob_endpoint
  # ... other variables
}
