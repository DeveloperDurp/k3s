dnsserver = "192.168.20.1"

sshkeys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDTYqag8OKcV6kIitn3Axlyi3Xr9EeybG10wlglw34fYF0pY+OERy7zZKEju4ijZzQ7eWNlcXLYSorm5Tngkvnz4vbM4b9R7gZjTV9drSGDo0BLkMXNuSTrKwGeokcNkxh+HZcWSK4/SE5zPzvkPj1UvmAgQ4P4N79mqPe5/9gAvdrlUWEtuqVdEHc/FMk4kEZsRu4lg58KoghNCRYMYHOyd1rbHsuWpX5NumPxnosWG22jzqj46rUWEXvA7MrCGGbUDlk5+/h7Bvw4O8nGZLEo/qyaYvChTBj/UqYYBssC4VlW/SNJB1yfrklqdtcknmFVJBi174cQtzZDXOerwneh8/+t7wWpcxkWscxYrwdJspzAU/NGk02xDPaG4F1mdgZ6HIZCQAaw/EbaNbiuU+bhdngEIHUvVmdiy4T09FWIWuJxO6FnAiVIU5K8LpqGLTFp7kjOwAczdQ+KVojm/1A5W/ZoTE/y3Ni1fVaOJFCxSgU7qiKAm7hb2ZXvznNgryc="

k3master = {
  count    = 1
  name     = ["k3s01"]
  cores    = 4
  memory   = "4096"
  drive    = "20G"
  storage  = "NVMeSSD"
  template = ["CentOS9-Template"]
  node     = ["overlord"]
  ip       = ["121"]
}

k3server = {
  count    = 4
  name     = ["node01", "node02","node03","node04"]
  cores    = 4
  memory   = "8192"
  drive    = ["60G","60G","60G","60G"]
  storage  = "NVMeSSD"
  template = ["CentOS9-Template","CentOS9-Template","CentOS9-Template","CentOS9-Template"]
  node     = ["overlord","overlord","overlord","overlord"]
  ip       = ["141", "142", "143", "144"]
}
