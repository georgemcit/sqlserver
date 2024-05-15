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
variable "name"{
 type=string
default="name"
}
variable "version"{
 type=string
 default="version"
}
variable "minimum_tls_version"{
 type=string
 default="minimum_tls_version"
}
