locals{
  mssql_server=[for f in fileset("${path.module}/${var.sqlserver}", "[^_]*.yaml") : yamldecode(file("${path.module}/${var.sqlserver}/${f}"))]
  mssql_server_list = flatten([
    for app in local.mssql_server: [
      for mysqlserver in try(app.listofmysqlserver, []) :{
        name=mysqlserver.mssqlserver
        version=mysqlserver.version
        minimum_tls_version=mysqlserver.minimum_tls_version 
      }
    ]
])
}
resource "azurerm_mssql_server" "azuresqlserver" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.database-rg.name
  location                     = azurerm_resource_group.database-rg.location
  version                      = each.value.version
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  minimum_tls_version          = each.value.minimum_tls_version

  azuread_administrator {
    login_username = "AzureAD Admin"
    object_id      = "00000000-0000-0000-0000-000000000000"
  }

  tags = {
    Environment = var.environment_tag
  }
}
