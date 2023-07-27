dnsserver = "192.168.20.1"

sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEjOeWMy3W7GyFQmWO90RXTAGHzOcIkqk4DuTrHn634m"

k3master = {
  count    = 1
  name     = ["master-dev"]
  cores    = 4
  memory   = "4096"
  drive    = "20G"
  storage  = "ssd-domains"
  template = ["Debian12-Template"]
  node     = ["overlord"]
  ip       = ["10"]
}

k3server = {
  count    = 1
  name     = ["node01-dev"]
  cores    = 4
  memory   = "4096"
  drive    = "60G"
  storage  = "ssd-domains"
  template = ["Debian12-Template"]
  node     = ["mothership"]
  ip       = ["20"]
}
