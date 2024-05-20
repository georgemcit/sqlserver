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
resource "azurerm_mssql_server" "george" {
  for_each            ={for mssqlserver in local.mssqlserver: "${sp.name}"=>mssqlserver }
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
 
