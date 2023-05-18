
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

## Usage for Set-AzureIKEPolicy

This script allows for the creation and setting of Azure VPN IKE policies easily since there is no way to do it within the Portal, in addition to all of the required parameters requires to actually set it through Powershell.

### Installation/Usage

Prior to running the script, you should log into Azure and select the appropriate Subscription context. 

This script can be run either within a normal Powershell ISE window or within VSCode. Please note when running inside of VSCode the **help text will not be available.**

The script can be either run as a whole and invoked using

```powershell
PS> Update-VPNIKEPolicy
```
Using this method will prompt you for all of the required parameters needed prior to executing the task. You can use **!?** to get more information on what the prompt is looking for if you aren't sure.
![Example of it running as whole function](https://i.imgur.com/jRf8xtv.gif)

You can also load the script up and run the individual functions. There is a parameter set that allows you to tab complete through the accepted values.

![Tab completion](https://i.imgur.com/OHGrspp.gif)
