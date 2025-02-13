# hcloud.tf

data "cloudinit_config" "vps_config" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"

    content = templatefile("${path.module}/cloud-config.yaml", {
      vps_hostname     = var.vps_hostname
      ssh_pubkey       = hcloud_ssh_key.main.name
      env_file_content = file("${path.module}/.env")
    })
  }
}

resource "hcloud_ssh_key" "main" {
  name       = "main_ssh_key"
  public_key = file("~/.ssh/id_ed25519_hetzner.pub")
}

resource "hcloud_server" "alma_vps" {
  name        = "alma-linux-vps"
  image       = "alma9"
  server_type = var.hcloud_server_type # uses a shared vCPU AMD instance by default (cx21: 2 vCPU, 4GB RAM, 2TB traffic)
  location    = var.hcloud_location    # change to your desired avail zone
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  firewall_ids = [hcloud_firewall.basic_firewall.id]
  ssh_keys     = [hcloud_ssh_key.main.name]
  user_data    = data.cloudinit_config.vps_config.rendered
  lifecycle {
    prevent_destroy = true
  }
}

resource "hcloud_firewall" "basic_firewall" {
  name = "first_defense"
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "2200"                # ensuring all external server ports are closed except custom ssh port 2200
    source_ips = ["0.0.0.0/0", "::/0"] # ssh allowable over internet (all ipv4s + ipv6 IPs)
  }
  lifecycle {
    prevent_destroy = true
  }
}