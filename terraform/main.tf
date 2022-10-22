data "digitalocean_ssh_key" "evo-laptop" {
  name = "evo-laptop"
}

resource "digitalocean_droplet" "app1" {
  image    = "ubuntu-22-04-x64"
  name     = "app-1"
  region   = "sfo3"
  size     = "s-1vcpu-1gb"
  ssh_keys = [data.digitalocean_ssh_key.evo-laptop.id]
}

resource "digitalocean_droplet" "app2" {
  image    = "ubuntu-22-04-x64"
  name     = "app-2"
  region   = "sfo3"
  size     = "s-1vcpu-1gb"
  ssh_keys = [data.digitalocean_ssh_key.evo-laptop.id]
}

resource "digitalocean_domain" "domain" {
  name = "terraform-sandbox.tk"
}

resource "digitalocean_record" "record-1" {
  domain = digitalocean_domain.domain.name
  type   = "A"
  name   = "@"
  value  = digitalocean_loadbalancer.lb.ip
}

resource "digitalocean_certificate" "cert" {
  name    = "terraform-sandbox"
  type    = "lets_encrypt"
  domains = [digitalocean_domain.domain.name]
}

resource "digitalocean_loadbalancer" "lb" {
  name   = "loadbalancer-1"
  region = "sfo3"

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 3000
    target_protocol = "http"

  }

  forwarding_rule {
    entry_port     = 443
    entry_protocol = "https"

    target_port     = 3000
    target_protocol = "http"

    certificate_name = digitalocean_certificate.cert.id
  }

  healthcheck {
    port     = 3000
    protocol = "tcp"
  }

  droplet_ids = [digitalocean_droplet.app1.id, digitalocean_droplet.app2.id]
}
