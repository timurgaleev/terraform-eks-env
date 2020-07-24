terraform {
  backend "s3" {
    bucket         = "tfstate-demo-infra"
    key            = "terraform/states/eks-demo-charts.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "tfstate_demo"
  }
  required_version = ">= 0.12.0"
}

### Module: network
module "network" {
  source             = "./modules/network"

  environment        = var.environment

  availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]

  cluster_name       = var.cluster_name

  ### vpc: 10.${var.network}.0.0/16
  network            = var.network_id
}

### Module: Kubernetes 

module "kubernetes" {
  source              = "./modules/kubernetes"

  environment         = var.environment
  cluster_name        = var.cluster_name
  max_cluster_size    = var.spot_max_cluster_size
  desired_capacity    = var.spot_desired_capacity
  min_cluster_size    = var.spot_min_cluster_size
  cluster_version     = var.cluster_version
  instance_type       = var.spot_instance_type
  aws_region          = data.aws_region.current.name
  vpc_id              = module.network.vpc_id
  private_subnets     = module.network.private_subnets
}

### Modules

module "artifactory" {
  source = "./modules/artifactory"

  stable_chartmuseum_version    = var.stable_chartmuseum
  oteemo_sonatype_nexus_version = var.oteemo_sonatype_nexus
}

module "ingress" {
  source = "./modules/ingress"

  bitnami_external_dns_version  = var.bitnami_external_dns
  stable_nginx_ingress_version  = var.stable_nginx_ingress
  jetstack_cert_manager_version = var.jetstack_cert_manager
  stable_metrics_server_version = var.stable_metrics_server

  domain              = var.domains
  cert_manager_email  = var.cert_manager_email
  module_depends_on   = [module.monitoring.prometheus-operator]
}

module "monitoring" {
  source                              = "./modules/monitoring"
  stable_grafana_version              = var.stable_grafana
  stable_prometheus_adapter_version   = var.stable_prometheus_adapter
  stable_prometheus_operator_version  = var.stable_prometheus_operator
}

module "keycloak" {
  source                        = "./modules/keycloak"
  codecentric_keycloak_version  = var.codecentric_keycloak
  module_depends_on             = [module.monitoring.prometheus-operator]
}

# module "istio" {
#   source                                = "./modules/istio"
#   gabibbo97_keycloak_gatekeeper_version = var.gabibbo97_keycloak_gatekeeper
#   module_depends_on                     = [module.keycloak.keycloak_realese]
# }

module "weave" {
  source                                = "./modules/weave"
  gabibbo97_keycloak_gatekeeper_version = var.gabibbo97_keycloak_gatekeeper
  stable_weave_scope_version            = var.stable_weave_scope
  module_depends_on                     = [module.keycloak.keycloak_realese]
}

module "jenkins" {
  source            = "./modules/jenkins"
  module_depends_on = [module.monitoring.prometheus-operator]
  jenkins_version   = var.stable_jenkins
}

# module "spot_fleet_request" {
#   source = "./modules/spot_fleet"
# }

module "sonarqube" {
  source              = "./modules/sonarqube"
  module_depends_on   = [module.monitoring.prometheus-operator]
  sonarqube_version   = var.oteemo_sonarqube
}

module "loki" {
  source            = "./modules/logging/loki"
  module_depends_on = [module.monitoring.prometheus-operator]
}

module "rds" {
  source        = "./modules/rds"

  environment   = var.environment
  cluster_name  = var.cluster_name
  vpc_id        = module.network.vpc_id

  ### DB settings:
  db_backup_retention = "30"
  instance_class      = "db.t2.micro"
  allocated_storage   = "5"
}

module "argo" {
  source                                = "./modules/argo"
  module_depends_on                     = [module.monitoring.prometheus-operator, module.keycloak.keycloak_realese]
  aws_region                            = data.aws_region.current.name
  argo_argo_version                     = var.argo_argo
  argo_argo_events_version              = var.argo_argo_events
  gabibbo97_keycloak_gatekeeper_version = var.gabibbo97_keycloak_gatekeeper
  argo_argo_rollouts_version            = var.argo_argo_rollouts
  argo_argo_cd_version                  = var.argo_argo_cd
}