
# Code Snippets

Code snippets that I use and want to remember. A mix of Terraform and Powershell mostly.


## Requirements

### Powershell
Most of these modules are using the `Az` module in Powershell. Make sure this is installed when you are using it.

### Terraform
The code is meant to be able to be used in a modular fashion and deployed either through Terraform Cloud or Terraform OSS with minimal modifications. Ensure that the Terraform application is installed. Additionally, ensure that the environmental variables for deployment are set:

#### Powershell Variable Set
```powershell
$env:ARM_CLIENT_ID="<service_principal_app_id>"
$env:ARM_SUBSCRIPTION_ID="<azure_subscription_id>"
$env:ARM_TENANT_ID="<azure_subscription_tenant_id>"
$env:ARM_CLIENT_SECRET="<service_principal_password>"
```

#### bash Variable Set
```bash
export ARM_SUBSCRIPTION_ID="<azure_subscription_id>"
export ARM_TENANT_ID="<azure_subscription_tenant_id>"
export ARM_CLIENT_ID="<service_principal_appid>"
export ARM_CLIENT_SECRET="<service_principal_password>"
. ~/.bashrc
```
