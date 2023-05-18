<#

    .SYNOPSIS
    Easily modifies Azure VPN IKE policies
    
    .DESCRIPTION
    Creates the IKE policy for existing VPN tunnels in Azure. 

    This can be run interactively where it prompts for every required feature (and can use !? for information) or you can run it via commandline after loading in the module. 

    .NOTES
    Minimum OS: 2012 
    Minimum PoSh: 4.0

#>

# **** ENSURE THAT YOU AUTH AND SELECT THE PROPER AZURE SUBSCRIPTION BEFORE RUNNING ****** 


        ##########################################
        #             Update IKE policy          #
        ##########################################
function Set-AzureVPNConnection {
    #Define parameters
    [CmdletBinding()] 
    Param (
        [Parameter(Mandatory = $true,HelpMessage = "What is the name of the Resource Group for the connection?")]
        [string]$ResourceGroupName,
        
        [Parameter(Mandatory = $true,HelpMessage = "What is the name of the VPN Gateway?")]
        [string]$VPNGatewayName,
        
        [Parameter(Mandatory = $true,HelpMessage = "What is the name of the local network gateway?")]
        [string]$LocalNetGatewayName,
        
        [Parameter(Mandatory = $true,HelpMessage = "What is the name of the VPN connection you want to modify?")]
        [string]$VPNConnectionName,
        
        [Parameter(Mandatory = $true,HelpMessage = "Select region the connection is in (i.e. West Central US) - enter as full string.")]
        [string]$ResourceLocationName
    )


    #Pull VNet Gateway
    $vnet1gw = Get-AzureRmVirtualNetworkGateway -Name $VPNGatewayName  -ResourceGroupName $ResourceGroupName

    #Pull Local Network Gateway
    $lng = Get-AzureRmLocalNetworkGateway  -Name $LocalNetGatewayName -ResourceGroupName $ResourceGroupName

    #Set Connection string to the VPN
    $global:connection1  = Get-AzureRmVirtualNetworkGatewayConnection -Name $VPNConnectionName -ResourceGroupName $ResourceGroupName

}

function Set-VPNIkePolicy {
    #Define parameters
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true,HelpMessage = "Enter value for IPSec Encryption Policy")]
        [ValidateNotNullorEmpty()]
        [ValidateSet("None", "DES", "DES3", "AES128", "AES192", "AES256", "GCMAES128", "GCMAES192", "GCMAES256")]
        [string]$IPSecEncryption,

        [Parameter(Mandatory = $true,HelpMessage = "Enter value for IPSec Integrity Policy")]
        [ValidateNotNullorEmpty()]
        [ValidateSet("MD5", "SHA1", "SHA256", "GCMAES128", "GCMAES192", "GCMAES256")]
        [string]$IPSecIntegrity,

        [Parameter(Mandatory = $true,HelpMessage = "Enter value for IKE Encryption Policy")]
        [ValidateNotNullorEmpty()]
        [ValidateSet("DES", "DES3", "AES128", "AES192", "AES256")]
        [string]$IKEEncryption,

        [Parameter(Mandatory = $true,HelpMessage = "Enter value for IKE Integrity Policy")]
        [ValidateNotNullorEmpty()]
        [ValidateSet("MD5", "SHA1", "SHA256", "SHA384")]
        [string]$IKEIntegrity,

        [Parameter(Mandatory = $true,HelpMessage = "Enter value for DH Group")]
        [ValidateNotNullorEmpty()]
        [ValidateSet("None", "DHGroup1", "DHGroup14", "DHGroup2", "DHGroup2048", "DHGroup24", "ECP256", "ECP384")]
        [string]$DHGroup,

        [Parameter(Mandatory = $true,HelpMessage = "Enter value for PFS Group")]
        [ValidateNotNullorEmpty()]
        [ValidateSet("None", "PFS1", "PFS2", "PFS2048", "PFS24", "ECP256", "ECP384")]
        [string]$PFSGroup,

        [Parameter(Mandatory = $true,HelpMessage = "Enter value for SA Lifetime (in seconds)")]
        [string]$SALifeTimeSeconds,

        [Parameter(Mandatory = $true,HelpMessage = "Enter value for SA Data Size (in KB)")]
        [string]$SADataSizeKilobytes,

        [Parameter(Mandatory = $true,HelpMessage = "Should you use Policy Based Traffic Selectors?")]
        [ValidateNotNullorEmpty()]
        [ValidateSet("true", "false", "True", "False")]
        [string]$PolicyBasedTrafficSelectors
    )

    #Creates the policy
    $newIPSecPolicy = New-AzureRmIpsecPolicy -IkeEncryption $IKEEncryption -IkeIntegrity $IKEIntegrity -DhGroup $DHGroup -IpsecEncryption $IPSecEncryption -IpsecIntegrity $IPSecIntegrity -PfsGroup $PFSGroup -SALifeTimeSeconds $SALifeTimeSeconds -SADataSizeKilobytes $SADataSizeKilobytes

    #Sets policy on connection outlined in Set-AzureVPNConnection based on Policy Based Traffic Selectors
    If ($PolicyBasedTrafficSelectors -eq 'True' -or $PolicyBasedTrafficSelectors -eq 'true') {
    Set-AzureRmVirtualNetworkGatewayConnection -VirtualNetworkGatewayConnection $connection1 -ResourceGroupName $ResourceGroupName -IpsecPolicies $newIPSecPolicy -UsePolicyBasedTrafficSelectors $true
    } else {
    Set-AzureRmVirtualNetworkGatewayConnection -VirtualNetworkGatewayConnection $connection1 -ResourceGroupName $ResourceGroupName -IpsecPolicies $newIPSecPolicy -UsePolicyBasedTrafficSelectors $false
    }

}

function Update-VPNIKEPolicy {
    Set-AzureVPNConnection
    Set-VPNIkePolicy
}
