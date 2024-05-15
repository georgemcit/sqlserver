locals{
  sql_server=[for f in fileset("${path.module}/${var.sqlserver}", "[^_]*.yaml") : yamldecode(file("${path.module}/${var.sqlserver}/${f}"))]
  sql_server_list = flatten([
    for app in local.sql_server: [
      for sqlserver in try(app.listofsqlserver, []) :{
        name=linuxapps.mssqlserver
        version=sqlserver.version
        minimum_tls_version=sqlserver.minimum_tls_version 
      }
    ]
])
}
