variable "subscription_id"{
  type=string
}
variable "client_id"{
  type=string
}
variable "client_secret"{
  type=string
}
variable "tenant_id"{
  type=string
}
variable "administrator_login"{
  type=string
}
variable "administrator_login_password"{
  type=string
}
variable "environment"{
 type=string
default="staging"
}
variable "sql_server_name"{
 type=string
default="mssqlserver"
}
variable "sql_version"{
 type=string
 default="12.0"
}
variable "minimum_tls_version"{
 type=string
 default="1.2"
}
variable "sqlserver"{
 type=string
 default=" default="
}
