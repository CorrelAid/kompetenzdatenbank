terraform {
  required_providers {
    hetznerdns = {
      source  = "timohirt/hetznerdns"
      version = "2.2.0"
    }

    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.47.0"
    }

    github = {
      source  = "integrations/github"
      version = "5.26.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
  }
}


provider "hcloud" {}


provider "hetznerdns" {}


provider "github" {
  owner = var.github.owner
}
