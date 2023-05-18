resource "random_string" "resource_prefix" {
  length  = 6
  special = false
  upper   = false
  numeric  = false
}

data "azurerm_client_config" "current" {
}

locals {
  resource_group_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/resource-group-name-here" # Change the resource group name to where it's being deployed.
}

data "azurerm_resource_group" "resource_group" {
  name                = var.resource_group_name
}

resource "azurerm_role_assignment" "aro_cluster_service_principal_network_contributor" {
  scope                = var.virtual_network_id
  role_definition_name = "Contributor"
  principal_id         = var.aro_cluster_aad_sp_object_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "aro_resource_provider_service_principal_network_contributor" {
  scope                = var.virtual_network_id
  role_definition_name = "Contributor"
  principal_id         = var.aro_rp_aad_sp_object_id
  skip_service_principal_aad_check = true
}

resource "azapi_resource" "aro_cluster" {
  name      = var.cluster_name
  count = var.deploy? 1:0
  location  = var.location
  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
  }
  parent_id = data.azurerm_resource_group.resource_group.id
  type      = "Microsoft.RedHatOpenShift/openShiftClusters@2022-04-01"
  
  body = jsonencode({
    properties = {
      clusterProfile = {
        domain               = var.domain
        fipsValidatedModules = var.fips_validated_modules
        resourceGroupId      = local.resource_group_id
        pullSecret           = var.pull_secret
      }
      networkProfile = {
        podCidr              = var.pod_cidr
        serviceCidr          = var.service_cidr
      }
       servicePrincipalProfile = {
        clientId             = var.aro_cluster_aad_sp_client_id
        clientSecret         = var.aro_cluster_aad_sp_client_secret
      }
      masterProfile = {
        vmSize               = var.master_node_vm_size
        subnetId             = var.master_subnet_id
        encryptionAtHost     = var.master_encryption_at_host
      }
      workerProfiles = [
        {
          name               = var.worker_profile_name
          vmSize             = var.worker_node_vm_size
          diskSizeGB         = var.worker_node_vm_disk_size
          subnetId           = var.worker_subnet_id
          count              = var.worker_node_count
          encryptionAtHost   = var.worker_encryption_at_host
        }
      ]
      apiserverProfile = {
        visibility           = var.api_server_visibility
      }
      ingressProfiles = [
        {
          name               = var.ingress_profile_name
          visibility         = var.ingress_visibility
        }
      ]
    }
  })

  lifecycle {
    ignore_changes = [
        tags
    ]
  }
}
