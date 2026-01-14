🛡️ Azure Enterprise Infrastructure for eShopOnWebArchitecte Cloud & DevOps : Chamseddine Boughanmi 1Stack : Terraform, Azure, Docker, SQL Private Link🏗️ Architecture Design (Hub-and-Spoke)Cette infrastructure implémente une topologie réseau hautement sécurisée pour isoler les composants critiques de l'application eShopOnWeb2222.+21. Networking & SegmentationLe réseau est orchestré via un Virtual Network (VNet) avec un espace d'adressage 10.0.0.0/163:snet-webapp (10.0.1.0/24) : Dédié à l'intégration VNet de l'App Service avec délégation Microsoft.Web/serverFarms4444.+1snet-db (10.0.2.0/24) : Segment isolé pour les services de base de données5.snet-management (10.0.3.0/24) : Réservé aux agents DevOps et à l'administration6.snet-endpoints (10.0.4.0/24) : Dédié aux Private Endpoints pour le trafic interne sécurisé7.2. Sécurité & IdentitéZero Trust Data Access : Le serveur SQL est protégé par un Private Endpoint et une Private DNS Zone (privatelink.database.windows.net)8.Managed Identity : L'authentification entre la Web App et l'Azure Container Registry (ACR) s'effectue via une User Assigned Identity 999avec le rôle AcrPull10.+2Secret Management : Un Azure Key Vault (SKU Premium) avec ACL réseaux restreints stocke les secrets et certificats11.🛠️ Composants de l'InfrastructureLogiciel (Application Tier)Azure Linux Web App : Exécute le conteneur eshopweb:v312121212.+1Monitoring : Pile complète avec Application Insights et Log Analytics pour le traçage distribué13.Données (Data Tier)SQL Server : Instance version 12.0 avec TLS 1.2 forcé14141414.+1Databases : Isolation logique des schémas Catalog et Identity15.Firewall Rules : Accès limité par IP pour la gestion via la VM DevOps (4.225.201.144)16.🚀 Deployment WorkflowConfiguration du Backend DistantL'état (state) est stocké de manière sécurisée sur Azure pour permettre le verrouillage (locking) et la collaboration17:Terraform# backend.tf
terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "steshopstatechams2026"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
ExécutionBash# 1. Initialisation et téléchargement des modules
terraform init

# 2. Validation de la syntaxe et des dépendances
terraform validate

# 3. Génération du plan d'exécution
terraform plan -out=infra.tfplan

# 4. Déploiement
terraform apply "infra.tfplan"
📊 Outputs & ObservabilitéÀ la fin du déploiement, le système expose les points d'entrée critiques18:Web App URL : Lien public direct vers l'application19.ACR Login Server : Endpoint pour les futurs pipelines CI/CD.Key Vault URI : Point d'accès pour la gestion des secrets.🛡️ Security Hardening (Résumé)MesureImplémentationTrafic DBTunnel privé via Private Link (Pas d'IP publique) 20IdentitéPasswordless via Managed Identity 21SecretsChiffrement au repos dans Key Vault Premium 22RéseauSegmentation stricte par Subnets et NSG 23232323+1IAAS DestructionProtection contre la suppression accidentelle du Resource Group 24Maintained by : Chamseddine Boughanmi Ce projet est une démonstration d'automatisation Cloud pour l'excellence opérationnelle.
