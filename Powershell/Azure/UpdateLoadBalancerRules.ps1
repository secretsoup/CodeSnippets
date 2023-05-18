# There is currently no way to add a range of IPs to an Azure Load Balancer rule. This script iterates through a set number to create rules as needed.
# Set $i -le to the amount of rules you want to count through
# Ensure that -FrontendIPConfigurations array object is correct

$lbName = "" # Name of the load balancer you are editing
$rgName = "" # Name of the resource group where the load balancer is
$healthProbeName = "" # Name of the health probe you want to assign
$backendPoolName = "" # Name of the backend pool you are assigning

$slb = Get-AzLoadBalancer -Name $lbName -ResourceGroupName $rgName
$healthProbe = Get-AzLoadBalancerProbeConfig -LoadBalancer $slb -Name $healthProbeName
$backendPool = Get-AzLoadBalancerBackendAddressPoolConfig -LoadBalance $slb -Name $backendPoolName

# Begin for loop - MAKE SURE TO CHANGE LENGTH TO HOW MANY YOU WANT
# MAKE SURE TO CHANGE PORT TO WHAT YOU WANT

for ($i = 1; $i -le 40; $i++) {
  $name = "LoadBalancerRule$i"
  $frontendPort = 5000 + $i
  $backendPort = 5000 + $i
  $slb | Add-AzLoadBalancerRuleConfig -Name $name -FrontendIPConfiguration $slb.FrontendIpConfigurations[2] -Protocol "Tcp" -FrontendPort $frontendPort -BackendPort $backendPort -EnableFloatingIP -BackendAddressPool $backendPool -Probe $healthProbe
 }

# This applies the changes above

$slb | Set-AzLoadBalancer 
