# Database Module - eShopOnWeb

## Description
Ce module Terraform permet de provisionner une instance **Azure SQL Server** sécurisée ainsi que les bases de données nécessaires à l'application **eShopOnWeb** (Catalog et Identity). Il configure également les règles de pare-feu (Firewall) pour restreindre l'accès au trafic provenant uniquement des services Azure et de l'agent DevOps.

## Ressources Créées
- **Azure SQL Server** : Instance principale avec enforcement TLS 1.2.
- **SQL Databases** : 
  - `eshop-catalog` : Stockage des produits.
  - `eshop-identity` : Gestion des utilisateurs.
- **Firewall Rules** : 
  - `AllowAzureServices` : Accès pour la Web App.
  - `AllowDevVM` : Accès pour les migrations de base de données depuis l'agent de build.

## Configuration (Inputs)

| Nom | Type | Description | Sensible |
|:---|:---:|:---|:---:|
| `resource_group_name` | `string` | Nom du Resource Group Azure. | Non |
| `location` | `string` | Région Azure (ex: West Europe). | Non |
| `db_subnet_id` | `string` | ID du Subnet dédié à la DB (pour intégration VNet). | Non |
| `db_password` | `string` | Mot de passe administrateur SQL. | **Oui** |

## Sorties (Outputs)

| Nom | Description |
|:---|:---|
| `sql_server_fqdn` | L'adresse DNS complète du serveur SQL. |
| `sql_server_name` | Le nom brut du serveur SQL. |
| `sql_server_id` | L'identifiant Azure de la ressource. |

## Exemple d'Utilisation

```hcl
module "database" {
  source              = "./modules/database"
  resource_group_name = var.rg_name
  location            = var.location
  db_subnet_id        = module.networking.db_subnet_id
  db_password         = var.sql_admin_password
}
