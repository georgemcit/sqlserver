locals{
  my_sql_app=[for f in fileset("${path.module}/${var.sqlserver}", "[^_]*.yaml") : yamldecode(file("${path.module}/${var.sqlserver}/${f}"))]
  my_sql_app_list = flatten([
    for app in local.my_sql_app: [
      for serverapps in try(app.listofmysqlserver, []) :{
        name=serverapps.name
        version=serverapps.server_version
      }
    ]
])
}
resource "azurerm_resource_group" "databaserg" {
  name     = "database-rg"
  location = "West Europe"
}

resource "azurerm_mssql_server" "azuresqlserver" {
  for_each            ={for sp in local.my_sql_app_list: "${sp.name}"=>sp }
  name                = each.value.name
  version             = each.value.server_version
  resource_group_name          = azurerm_resource_group.databaserg.name
  location                     = azurerm_resource_group.databaserg.location
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
