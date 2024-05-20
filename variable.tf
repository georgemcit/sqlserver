locals{
  mssql_server=[for f in fileset("${path.module}/sqlserver", "[^_]*.yaml") : yamldecode(file("${path.module}/sqlserver/${f}"))]
  sqlserverlist = flatten([
    for app in local.mssql_server : [
      for mssql_server in try(app.listofmssqlserver, []) :{
        name=mssql_server.mssqlservername
        allocation_method=mssqlserver.allocation_method

      }
    ]
])
}

resource "azurerm_resource_group" "databaserg" {
  name     = "database-rg"
  location = "West Europe"
}

resource "azurerm_mssql_server" "azuresqlserver" {
  for_each            ={for sp in local.mssql_server: "${sp.name}"=>sp }
  name                         = "mssqlserver"
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

