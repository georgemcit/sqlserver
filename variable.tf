locals{
  mysql_server=[for f in fileset("${path.module}/sqlserver", "[^_]*.yaml") : yamldecode(file("${path.module}/sqlserver/${f}"))]
  mysql_server_list = flatten([
    for app in local.mysql_server : [
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
  version             = var.version.number
  minimum_tls_versione            = "1.2"


azuread_administrator {
    login_username = "AzureAD Admin"
    object_id      = "00000000-0000-0000-0000-000000000000"
  }

  tags = {
    environment = "production"
  }
}
 
