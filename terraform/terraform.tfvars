dnsserver = "192.168.20.1"

sshkeys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDTYqag8OKcV6kIitn3Axlyi3Xr9EeybG10wlglw34fYF0pY+OERy7zZKEju4ijZzQ7eWNlcXLYSorm5Tngkvnz4vbM4b9R7gZjTV9drSGDo0BLkMXNuSTrKwGeokcNkxh+HZcWSK4/SE5zPzvkPj1UvmAgQ4P4N79mqPe5/9gAvdrlUWEtuqVdEHc/FMk4kEZsRu4lg58KoghNCRYMYHOyd1rbHsuWpX5NumPxnosWG22jzqj46rUWEXvA7MrCGGbUDlk5+/h7Bvw4O8nGZLEo/qyaYvChTBj/UqYYBssC4VlW/SNJB1yfrklqdtcknmFVJBi174cQtzZDXOerwneh8/+t7wWpcxkWscxYrwdJspzAU/NGk02xDPaG4F1mdgZ6HIZCQAaw/EbaNbiuU+bhdngEIHUvVmdiy4T09FWIWuJxO6FnAiVIU5K8LpqGLTFp7kjOwAczdQ+KVojm/1A5W/ZoTE/y3Ni1fVaOJFCxSgU7qiKAm7hb2ZXvznNgryc="

k3master = {
  count    = 6
  name     = ["master01", "master02", "master03","master04", "master05", "master06"]
  cores    = 2
  memory   = "2048"
  drive    = "20G"
  storage  = "NVMeSSD"
  template = ["CentOS9-Template","CentOS9-Template","CentOS9-Template","CentOS9-Template2","CentOS9-Template2","CentOS9-Template2"]
  node     = ["overlord","overlord","overlord","mothership","mothership","mothership"]
  ip       = ["121", "122", "123","124", "125", "126"]
}

k3server = {
  count    = 6
  name     = ["node01", "node02","node03", "node04","node05", "node06"]
  cores    = 4
  memory   = "8192"
  drive    = ["160G","20G","20G","160G","20G","20G"]
  storage  = "NVMeSSD"
  template = ["CentOS9-Template","CentOS9-Template","CentOS9-Template","CentOS9-Template2","CentOS9-Template2","CentOS9-Template2"]
  node     = ["overlord","overlord","overlord","mothership","mothership","mothership"]
  ip       = ["141", "142", "143","144", "145", "146"]
}
