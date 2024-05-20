locals{
  mysql_server=[for f in fileset("${path.module}/sqlserver", "[^_]*.yaml") : yamldecode(file("${path.module}/sqlserver/${f}"))]
  mysql_server_list = flatten([
    for app in local.mssql_server : [
      for mysqlservers in try(app.listofmssqlserver, []) :{
        name=mysqlservers.name

      }
    ]
])
}
resource "azurerm_resource_group" "databaserg" {
  name     = "database-rg"
  location = "West Europe"
}
resource "azurerm_mssql_server" "george" {
  for_each            ={for mysqlserver in local.mysql_server: "${sp.name}"=>mysqlserver }
  name                = each.value.name
  resource_group_name = azurerm_resource_group.databaserg.name
  location            = azurerm_resource_group.databaserg.location
  version             = each.value. version
  minimum_tls_versione            = each.value.minimum_tls_version


azuread_administrator {
    login_username = "AzureAD Admin"
    object_id      = "00000000-0000-0000-0000-000000000000"
  }

  tags = {
    environment = "production"
  }
}
 
