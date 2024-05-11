dnsserver = "192.168.10.1"

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
  count    = 2
  name     = ["node01-dev", "node02-dev"]
  cores    = 4
  memory   = "4096"
  drive    = "60G"
  storage  = "ssd-domains"
  template = ["Debian12-Template", "Debian12-Template"]
  node     = ["mothership", "mothership"]
  ip       = ["20", "21"]
}
