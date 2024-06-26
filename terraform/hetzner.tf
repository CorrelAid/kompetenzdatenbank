resource "hcloud_firewall" "firewall" {
  name = var.project_name
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "80"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "443"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }


}

resource "hcloud_primary_ip" "main" {
  count         = length(var.server)
  name          = var.server[count.index].name
  datacenter    = var.server[count.index].location
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = true
}


# Create server for deployment
resource "hcloud_server" "main" {
  count        = length(var.server)
  name         = var.server[count.index].name
  image        = var.server[count.index].image
  server_type  = var.server[count.index].server_type
  datacenter   = var.server[count.index].location
  backups      = var.server[count.index].backups
  firewall_ids = [hcloud_firewall.firewall.id]
  public_net {
    ipv4         = hcloud_primary_ip.main[count.index].id
    ipv6_enabled = false
  }
  user_data = templatefile("user_data.tmpl", { user = var.server[count.index].user })
}











