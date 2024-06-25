variable "project_name" {
  type        = string
  description = "Project name"
  default     = "test"

}

variable "server" {
  type = list(object({
    name        = string
    server_type = string
    image       = string
    location    = string
    backups     = bool
    user        = string
  }))
  description = "Server configuration list"
  default = [
    {
      name        = "test-dev"
      server_type = "cpx11"
      image       = "ubuntu-22.04"
      location    = "fsn1-dc14"
      backups     = true
      user        = "deployer"
    },
    {
      name        = "test-prod"
      server_type = "ccx23"
      image       = "ubuntu-22.04"
      location    = "fsn1-dc14"
      backups     = true
      user        = "deployer"
    }
  ]
}

variable "github" {
  type        = map(any)
  description = "Github config map"
  default = {
    repo  = "kompetenzdatenbank"
    owner = "CorrelAid"
  }
}


variable "dns" {
  type = list(object({
    zone      = string
    subdomain = string
  }))
  description = "DNS configuration list"
  default = [
    {
      zone      = "correlaid.org"
      subdomain = "kompetenzdatenbank"
    },
    {
      zone      = "correlaid.org"
      subdomain = "kompetenzdatenbank"
    }
  ]
}


