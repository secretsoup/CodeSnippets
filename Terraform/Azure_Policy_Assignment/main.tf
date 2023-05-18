data "azurerm_management_group" "sandbox_mg" {
  name = var.stored_management_group_id
}

resource "azurerm_management_group_policy_assignment" "vm-policy-set-assignment" {
  name                 = "VM Policy Set"
  policy_definition_id = azurerm_policy_set_definition.vm-polciy-set-def.id
  management_group_id = data.azurerm_management_group.sandbox_mg.id

  description  = "Collection of VM Policy applicable to a specified scope"
  display_name = "VM Policy Set"
  identity {
    type = "SystemAssigned"
  }

  location = var.identity_location
}

resource "azurerm_policy_set_definition" "vm-polciy-set-def" {

  name                  = "VM Policy Set"
  policy_type           = "Custom"
  display_name          = "VM Policy Set"
  management_group_id = data.azurerm_management_group.sandbox_mg.id

  policy_definition_reference {
    # "Audit virtual machines without disaster recovery configured"
    # Applicable Effects: auditIfNotExists
    # Parameters: None
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/0015ea4d-51ff-4ce3-8d8c-f3f8f0179a56"
  }

  policy_definition_reference {
    # "Audit VMs that do not use managed disks"
    # Applicable Effects: Audit
    # Parameters: None
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d"
  }

  policy_definition_reference {
    # "Azure Backup should be enabled for Virtual Machines"
    # Applicable Effects: auditIfNotExists(Default), Disabled
    # Parameters: effect
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/013e242c-8828-4970-87b3-ab247555486d"
  }

  policy_definition_reference {
    # "Virtual machines should have the Log Analytics extension installed"
    # Applicable Effects: auditIfNotExistsm Disabled
    # Parameters: effect
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/a70ca396-0a34-413a-88e1-b956c1e683be"
  }

    policy_definition_reference {
    # "Windows virtual machines should have Azure Monitor Agent installed"
    # Applicable Effects: auditIfNotExistsm Disabled
    # Parameters: effect
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/c02729e5-e5e7-4458-97fa-2b5ad0661f28"
  }

    policy_definition_reference {
    # "Add system-assigned managed identity to enable Guest Configuration assignments on virtual machines with no identities"
    # Applicable Effects: Modify
    # Parameters: None
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/3cf2ab00-13f1-4d0c-8971-2ac904541a7e"
  }
    policy_definition_reference {
    # "Windows machines should meet requirements for 'Security Options - Network Security'"
    # Applicable Effects: auditIfNotExistsm Disabled
    # Parameters: None
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/1221c620-d201-468c-81e7-2817e6107e84"
  }
    policy_definition_reference {
    # "Management ports of virtual machines should be protected with just-in-time network access control'"
    # Applicable Effects: auditIfNotExistsm Disabled
    # Parameters: None
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/b0f33259-77d7-4c9e-aac6-3aabcfae693c"
  }
    policy_definition_reference {
    # "Audit Linux machines that have accounts without passwords"
    # Applicable Effects: auditIfNotExistsm Disabled
    # Parameters: None
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/f6ec09a3-78bf-4f8f-99dc-6c77182d0f99"
  }
    policy_definition_reference {
    # "Audit Windows machines that do not have the password complexity setting enabled"
    # Applicable Effects: auditIfNotExistsm Disabled
    # Parameters: None
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/bf16e0bb-31e1-4646-8202-60a235cc7e74"
  }
    policy_definition_reference {
    # "Audit Windows machines that do not restrict the minimum password length to specified number of characters"
    # Applicable Effects: auditIfNotExistsm Disabled
    # Parameters: None
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/a2d0e922-65d0-40c4-8f87-ea6da2d307a2"
  }
    policy_definition_reference {
    # "Audit Windows machines that allow re-use of the passwords after the specified number of unique passwords"
    # Applicable Effects: auditIfNotExistsm Disabled
    # Parameters: None
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/5b054a0d-39e2-4d53-bea3-9734cad2c69b"
  }
    policy_definition_reference {
    # "Audit Linux machines that do not have the passwd file permissions set to 0644"
    # Applicable Effects: auditIfNotExistsm Disabled
    # Parameters: None
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e6955644-301c-44b5-a4c4-528577de6861"
  }
    policy_definition_reference {
    # "Windows web servers should be configured to use secure communication protocols"
    # Applicable Effects: auditIfNotExistsm Disabled
    # Parameters: None
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/5752e6d6-1206-46d8-8ab1-ecc2f71a8112"
  }
    policy_definition_reference {
    # "Virtual machines should encrypt temp disks, caches, and data flows between Compute and Storage resources"
    # Applicable Effects: auditIfNotExistsm Disabled
    # Parameters: None
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/0961003e-5a0a-4549-abde-af6a37f2724d"
  }
    policy_definition_reference {
    # "All network ports should be restricted on network security groups associated to your virtual machine"
    # Applicable Effects: auditIfNotExistsm Disabled
    # Parameters: None
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/9daedab3-fb2d-461e-b861-71790eead4f6"
  }
}
