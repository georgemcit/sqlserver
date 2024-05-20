locals{
  listmysqlserver=[for f in fileset("${path.module}/sqlserver", "[^_]*.yaml") : yamldecode(file("${path.module}/sqlserver/${f}"))]
  mysql_server_list = flatten([
    for app in local.listmysqlserver: [
      for mysqlserver in try(app.listmysqlserver, []) :{
        name=mysqlserver.mysqlserver
        version=mysqlserver.version
        minimum_tls_version=mysqlserver.minimum_tls_version 
      }
    ]
])
}

resource "azurerm_resource_group" "databaserg" {
  name     = "database-rg"
  location = "West Europe"
}

resource "azurerm_mssql_server" "azuresqlserver" {
  for_each            ={for sp in local.mysql_server_list: "${sp.name}"=>sp }
  name                         = "mysqlserver"
  resource_group_name          = azurerm_resource_group.databaserg.name
  location                     = azurerm_resource_group.databaserg.location
  version                      = "12.0"
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  minimum_tls_version          = "1.2"

  azuread_administrator {
    login_username = "AzureAD Admin"
    object_id      = "00000000-0000-0000-0000-000000000000"
  }

  tags = {
    environment = "production"
  }
}

