locals {
  routes = csvdecode(file("${path.module}/udr_routes_onprem.csv")) # Assumes the .csv is in the local file. 
}

resource "azurerm_route" "onpremroutes" {
    for_each = { for r in local.routes : r.route_name => r }
    name = each.key
    resource_group_name = var.rg_name
    route_table_name = var.rt_name
    address_prefix = each.value.destination_cidr
    next_hop_type = each.value.next_hop_type
    next_hop_in_ip_address = each.value.next_hop_ip_address
}
