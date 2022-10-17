#------------------------------------------------------
#Defaults

terraform {
  backend "http" {}
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "~> 2.9.11"
    }
  }
}

provider "proxmox" {
  pm_parallel     = 3
  pm_tls_insecure = true
  pm_api_url      = var.pm_api_url
  pm_user         = var.pm_user
  pm_password     = var.pm_password
  pm_debug        = false
}

variable "pm_api_url" {}
variable "pm_api_token_id" {}
variable "pm_api_token_secret" {}
variable "dnsserver" {}
variable "sshkeys" {}
variable "pm_password" {}
variable "pm_user" {}

#k3s
#------------------------------------------------------

variable "k3master" {
  type = object({
    count    = number
    name     = list(string)
    cores    = number
    memory   = number
    drive    = string
    storage  = string
    template = string
    node     = string
    tag      = number
    ip       = list(number)   
  })
}

variable "k3server" {
  type = object({
    count    = number
    name     = list(string)
    cores    = list(number)
    memory   = list(number)
    drive    = list(string)
    storage  = list(string)
    template = string
    node     = string
    tag      = number
    ip       = list(number)   
  })
}

resource "proxmox_vm_qemu" "k3master" {
  count       = var.k3master.count
  ciuser      = "administrator"
  vmid        = "${var.k3master.tag}${var.k3master.ip[count.index]}"
  name        = var.k3master.name[count.index]
  target_node = var.k3master.node
  clone       = var.k3master.template
  full_clone  = true
  os_type     = "cloud-init"
  agent       = 1
  cores       = var.k3master.cores
  sockets     = 1
  cpu         = "host"
  memory      = var.k3master.memory
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  boot        = "c"
  onboot      = true
  disk {
    size    = var.k3master.drive
    type    = "scsi"
    storage = var.k3master.storage
    ssd     = 0
    backup  = 0
  }
  network {
    model  = "virtio"
    bridge = "vmbr1"
    tag    = var.k3master.tag
  }
  lifecycle {
    ignore_changes = [
      network,
    ]
  }
  #Cloud Init Settings
  ipconfig0    = "ip=192.168.${var.k3master.tag}.${var.k3master.ip[count.index]}/24,gw=192.168.${var.k3master.tag}.1"
  searchdomain = "durp.loc"
  nameserver   = "${var.dnsserver}"
  sshkeys      = "${var.sshkeys}"
}

resource "proxmox_vm_qemu" "k3server" {
  count       = var.k3server.count
  ciuser      = "administrator"
  vmid        = "${var.k3server.tag}${var.k3server.ip[count.index]}"
  name        = var.k3server.name[count.index]
  target_node = var.k3server.node
  clone       = var.k3server.template
  full_clone  = true
  os_type     = "cloud-init"
  agent       = 1
  cores       = var.k3server.cores[count.index]
  sockets     = 1
  cpu         = "host"
  memory      = var.k3server.memory[count.index]
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  boot        = "c"
  onboot      = true
  disk {
    size    = var.k3server.drive[count.index]
    type    = "scsi"
    storage = var.k3server.storage[count.index]
    ssd     = 1
    backup  = 0
  }
  network {
    model  = "virtio"
    bridge = "vmbr1"
    tag    = var.k3server.tag
  }
  lifecycle {
    ignore_changes = [
      network,
    ]
  }
  #Cloud Init Settings
  ipconfig0    = "ip=192.168.${var.k3server.tag}.${var.k3server.ip[count.index]}/24,gw=192.168.${var.k3server.tag}.1"
  searchdomain = "durp.loc"
  nameserver   = "${var.dnsserver}"
  sshkeys      = "${var.sshkeys}"
}

resource "proxmox_vm_qemu" "kasm" {
  count       = 1
  ciuser      = "administrator"
  vmid        = 20110
  name        = "kasm"
  target_node = "overlord"
  clone       = "CentOS9-Template"
  full_clone  = true
  os_type     = "cloud-init"
  agent       = 1
  cores       = 2
  sockets     = 1
  cpu         = "host"
  memory      = 4096
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  boot        = "c"
  onboot      = true
  disk {
    size    = "60G"
    type    = "scsi"
    storage = "local-zfs"
    ssd     = 1
    backup  = 0
  }
  network {
    model  = "virtio"
    bridge = "vmbr1"
    tag    = 20
  }
  lifecycle {
    ignore_changes = [
      network,
    ]
  }
  #Cloud Init Settings
  ipconfig0    = "ip=192.168.20.110/24,gw=192.168.20.1"
  searchdomain = "durp.loc"
  nameserver   = "${var.dnsserver}"
  sshkeys      = "${var.sshkeys}"
}
