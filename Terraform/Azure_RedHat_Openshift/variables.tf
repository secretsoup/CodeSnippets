variable "cluster_name" {
  description = "Specifies the name for the cluster."
  type        = string
}

variable "location" {
  description = "Specifies the location of Azure resource."
  type        = string
}

variable "resource_group_name" {
  description = "Specifies the name of the resource group."
  type        = string
}

/* variable "resource_group_name_clusterprofile" {
  description = "Specifies the name of the resource group for Cluster Profile."
  type        = string
}
 */
/* variable "clusterprofile_resource_group_id" {
  description = "Specifies the id of the resource group for Cluster Profile."
  type        = string
} */

variable "domain" {
  description = "Specifies the domain prefix of the Azure Red Hat OpenShift cluster."
  type        = string
}

variable "pull_secret" {
  description = "Specifies the pull secret from cloud.redhat.com. The JSON should be provided as a string."
  type        = string
}

/* variable "virtual_network_address_space" {
  description = "Specifies the address space of the virtual virtual network hosting the Azure Red Hat OpenShift cluster."
  type        = list(string)
} */

variable "worker_subnet_name" {
  description = "Specifies the name of the worker node subnet."
  type        = string
}

variable "worker_subnet_address_space" {
  description = "Specifies the address space of the worker node subnet."
  type        = list(string)
}

variable "master_subnet_name" {
  description = "Specifies the name of the master node subnet."
  type        = string
}

variable "master_subnet_id" {
    description = "Specifies the id of the master node subnet."
    type        = string
}

variable "worker_subnet_id" {
    description = "Specifies the id of the worker node subnet."
    type        = string
}

variable "master_subnet_address_space" {
  description = "Specifies the address space of the master node subnet."
  type        = list(string)
}

variable "worker_node_vm_size" {
  description = "Specifies the VM size for worker nodes of the Azure Red Hat OpenShift cluster."
  type        = string
}

variable "master_node_vm_size" {
  description = "Specifies the VM size for master nodes of the Azure Red Hat OpenShift cluster."
  type        = string
}

variable "worker_profile_name" {
  description = "Specifies the name of the worker profile of the Azure Red Hat OpenShift cluster."
  type        = string
}

variable "worker_node_vm_disk_size" {
  description = "Specifies the VM disk size for worker nodes of the Azure Red Hat OpenShift cluster."
  type        = number
}

variable "worker_node_count" {
  description = "Specifies the number of worker nodes of the Azure Red Hat OpenShift cluster."
  type        = number
}

variable "pod_cidr" {
  description = "Specifies the CIDR for the pods."
  type        = string
}

variable "service_cidr" {
  description = "Specifies the CIDR for the services."
  type        = string
}

variable "api_server_visibility" {
  description = "Specifies the API Server visibility for the Azure Red Hat OpenShift cluster." 
}

variable "ingress_profile_name" {
  description = "Specifies the name of the ingress profile of the Azure Red Hat OpenShift cluster."
  type        = string
}

variable "ingress_visibility" {
  description = "Specifies the ingress visibility for the Azure Red Hat OpenShift cluster."
  }

variable "fips_validated_modules" {
  description = "Specifies whether FIPS validated crypto modules are used."
}

variable "master_encryption_at_host" {
  description = "Specifies whether master virtual machines are encrypted at host."
  }

variable "worker_encryption_at_host" {
  description = "Specifies whether master virtual machines are encrypted at host."
}

 variable "aro_cluster_aad_sp_client_id" {
  description = "Specifies the client id of the service principal of the Azure Red Hat OpenShift cluster."
  type        = string
}

variable "aro_cluster_aad_sp_client_secret" {
  description = "Specifies the client secret of the service principal of the Azure Red Hat OpenShift cluster."
  type        = string
}

variable "aro_cluster_aad_sp_object_id" {
  description = "Specifies the object id of the service principal of the Azure Red Hat OpenShift cluster."
  type        = string
}

variable "aro_rp_aad_sp_object_id" {
  description = "Specifies the object id of the service principal of the ARO resource provider."
  type        = string
}

variable "virtual_network_id" {
  description = "Specifies the id of the virtual network hosting the Azure Red Hat OpenShift cluster."
  type        = string
}

variable "deploy" {
  type = bool
  description = "Enter true to deploy and false to skip depoymentment of an aro cluster"
}
