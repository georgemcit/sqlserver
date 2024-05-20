locals{
  mssql_server=[for f in fileset("${path.module}/sqlserver", "[^_]*.yaml") : yamldecode(file("${path.module}/sqlserver/${f}"))]
  mssql_server_list = flatten([
    for app in local.mssql_server : [
      for mssqlservers in try(app.listofmssqlserver, []) :{
        name=linuxapps.name
        version=mssqlservers.version
        minimum_tls_versione=mssqlservers.minimum_tls_version

      }
    ]
])
}
resource "azurerm_resource_group" "databaserg" {
  name     = "database-rg"
  location = "West Europe"
}
resource "azurerm_mssql_server_plan" "george" {
  for_each            ={for sp in local.mssqlserver: "${sp.name}"=>sp }
  name                         = each.value.name
  resource_group_name = azurerm_resource_group.databaserg.name
  location            = azurerm_resource_group.databaserg.location
  version             = each.value. version
  minimum_tls_versione            = each.value.minimum_tls_version
}

resource "azurerm_mssql_server" "georgeibrahim" {
  for_each            = azurerm_service_plan.george
  name                = each.value.name
  resource_group_name = azurerm_resource_group.databaserg.name
  location            = azurerm_resource_group.databaserg.location
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  service_plan_id     = each.value.id

azuread_administrator {
    login_username = "AzureAD Admin"
    object_id      = "00000000-0000-0000-0000-000000000000"
  }

  tags = {
    environment = "production"
  }
}
 
