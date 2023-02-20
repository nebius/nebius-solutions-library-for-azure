### Azure
# Resource Group
resource "azurerm_resource_group" "az_rg" {
  name     = var.az_resource_group_name
  location = var.az_location
}

### YCloudIL
# Kubernetes Example Module
module "example_k8s" {
  count         = var.il_existing_k8s_cluster_name == "" ? 1 : 0 // run block if condition is satisfied 
  source        = "./kubernetes"
  il_folder_id  = var.il_folder_id
  il_cloud_id   = var.il_cloud_id
  il_zone       = var.il_zone
}

### Post-installation scripts
data "template_file" "az_il_arc_connect_script" {
  template = "${file("${path.module}/scripts/templates/az_connect_cloudil_k8s.tpl")}"

  vars = {
    az_subscription_id              = "${var.az_subscription_id}"
    az_service_principal_app_id     = "${var.az_service_principal_app_id}"
    az_service_principal_secret     = "${var.az_service_principal_secret}"
    az_service_principal_tenant_id  = "${var.az_service_principal_tenant_id}"
    az_resource_group_name          = "${var.az_resource_group_name}"
    az_location                     = "${var.az_location}"
    az_arc_cluster_name             = "${var.az_arc_cluster_name}"
    il_k8s_cluster_name             = "${var.il_existing_k8s_cluster_name == "" ? module.example_k8s[0].k8s-cluster-name : var.il_existing_k8s_cluster_name}"
    project                         = "azure-arc-demo"
  }
}

data "template_file" "az_il_arc_gitops_script" {
  template = "${file("${path.module}/scripts/templates/az_arc_gitops_config.tpl")}"

  vars = {
    az_arc_cluster_name             = "${var.az_arc_cluster_name}"
    az_resource_group_name          = "${var.az_resource_group_name}"
    project                         = "azure-arc-demo"
    repo                            = "https://github.com/knpsh/k8s-app"
  }
}

resource "local_file" "az_il_arc_connect_script" {
  content = data.template_file.az_il_arc_connect_script.rendered
  filename = "${path.module}/scripts/az_il_arc_connect_script.sh"
}

resource "local_file" "az_il_arc_gitops_script" {
  content = data.template_file.az_il_arc_gitops_script.rendered
  filename = "${path.module}/scripts/az_il_arc_gitops_script.sh"
}