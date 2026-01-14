# 📦 Module: Azure Storage Assets
**Project:** eShopOnWeb Infrastructure  
**Author:** Chamseddine Boughanmi  
**Contact:** [chamseddine.boughanmi@esprit.tn](mailto:chamseddine.boughanmi@esprit.tn)

---

## 📝 Description
This module manages the storage layer for the **eShopOnWeb** application. Instead of creating a new Storage Account, it leverages an existing one (used for Terraform State) to provision specific blob containers for application assets, such as product images.

## 🏗️ Resources Managed
- **Data Source (`azurerm_storage_account`)**: Connects to the existing `steshopstatechams2026` account in the `tfstate-rg` resource group.
- **Blob Container (`azurerm_storage_container`)**: Provisions the `images` container with public **blob-level access** for static asset delivery.

## 🛡️ Integration Note (Critical)
The module is designed to provide only the **Base Blob Endpoint**. The .NET application logic is configured to automatically append the container and asset paths (e.g., `/images/products/item.png`). This ensures a clean separation between infrastructure endpoints and application routing.

## 📥 Inputs (Variables)

| Name | Type | Description |
|:---|:---:|:---|
| `resource_group_name` | `string` | The Azure Resource Group hosting the storage resources. |
| `location` | `string` | The Azure region (e.g., West Europe). |

## 📤 Outputs

| Name | Description |
|:---|:---|
| `primary_blob_endpoint` | The primary base URL for the Blob service (e.g., `https://steshop...blob.core.windows.net/`). |

## 🚀 Usage Example

```hcl
module "storage" {
  source              = "./modules/storage"
  resource_group_name = "tfstate-rg"
  location            = var.location
}
