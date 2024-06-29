#resource "proxmox_vm_qemu" "VM" {
#  count       = 1
#  ciuser      = "administrator"
#  vmid        = "201"
#  name        = "TestVM"
#  target_node = "mothership"
#  clone       = "Debian12-Template"
#  qemu_os     = "other"
#  full_clone  = true
#  os_type     = "cloud-init"
#  agent       = 1
#  cores       = 2
#  sockets     = 1
#  cpu         = "host"
#  memory      = 2048
#  scsihw      = "virtio-scsi-pci"
#  bootdisk    = "scsi0"
#  boot        = "c"
#  onboot      = true
#  disk {
#    size    = "20G"
#    type    = "scsi"
#    format  = "raw"
#    storage = "ssd-domains"
#    ssd     = 1
#    backup  = true
#  }
#  network {
#    model  = "virtio"
#    bridge = "vmbr1"
#  }
#  lifecycle {
#    ignore_changes = [
#      network,
#    ]
#  }
#  #Cloud Init Settings
#  ipconfig0    = "ip=192.168.20.20/24,gw=192.168.20.1"
#  searchdomain = "durp.loc"
#  nameserver   = var.dnsserver
#  sshkeys      = var.sshkeys
#}
#

#k3s
#-----------------------------------------------------
locals {
  env_config = {
    prd = {

    }
    dev = {
      dnsserver = "192.168.10.1"
      k3master = {
        count    = 1
        name     = ["master-dev"]
        cores    = 4
        memory   = "4096"
        drive    = "20G"
        storage  = "cache-domains"
        template = ["Debian12-Template"]
        node     = ["overlord"]
        ip       = ["10"]
        vlan     = 10
      }
      k3server = {
        count    = 2
        name     = ["node01-dev", "node02-dev"]
        cores    = 4
        memory   = "4096"
        drive    = "60G"
        storage  = "cache-domains"
        template = ["Debian12-Template", "Debian12-Template"]
        node     = ["mothership", "mothership"]
        ip       = ["20", "21"]
        vlan     = 10
      }
    }
    default = {

    }
    config = merge(local.env_config["default"], lookup(local.env_config, var.environment, {}))
  }
}

resource "proxmox_vm_qemu" "k3master" {
  count       = local.config.k3master.count
  ciuser      = "administrator"
  vmid        = "${local.config.k3master.vlan}${local.config.k3master.ip[count.index]}"
  name        = local.config.k3master.name[count.index]
  target_node = local.config.k3master.node[count.index]
  clone       = local.config.k3master.template[count.index]
  qemu_os     = "other"
  full_clone  = true
  os_type     = "cloud-init"
  agent       = 1
  cores       = local.config.k3master.cores
  sockets     = 1
  cpu         = "host"
  memory      = local.config.k3master.memory
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  boot        = "c"
  onboot      = true
  disk {
    size    = local.config.k3master.drive
    type    = "scsi"
    format  = "raw"
    storage = local.config.k3master.storage
    ssd     = 1
    backup  = false
  }
  network {
    model  = "virtio"
    bridge = "vmbr1"
  }
  lifecycle {
    ignore_changes = [
      network,
    ]
  }
  #Cloud Init Settings
  ipconfig0    = "ip=192.168.${local.config.k3master.vlan}.${local.config.k3master.ip[count.index]}/24,gw=192.168.10.1"
  searchdomain = "durp.loc"
  nameserver   = local.config.dnsserver
}

#resource "proxmox_vm_qemu" "k3server" {
#  count       = var.k3server.count
#  ciuser      = "administrator"
#  vmid        = "${var.k3server.vlan}${var.k3server.ip[count.index]}"
#  name        = var.k3server.name[count.index]
#  target_node = var.k3server.node[count.index]
#  clone       = var.k3server.template[count.index]
#  qemu_os     = "other"
#  full_clone  = true
#  os_type     = "cloud-init"
#  agent       = 1
#  cores       = var.k3server.cores
#  sockets     = 1
#  cpu         = "host"
#  memory      = var.k3server.memory
#  scsihw      = "virtio-scsi-pci"
#  bootdisk    = "scsi0"
#  boot        = "c"
#  onboot      = true
#  disk {
#    size    = var.k3server.drive
#    type    = "scsi"
#    format  = "raw"
#    storage = var.k3server.storage
#    ssd     = 1
#    backup  = false
#  }
#  network {
#    model  = "virtio"
#    bridge = "vmbr1"
#  }
#  lifecycle {
#    ignore_changes = [
#      network,
#    ]
#  }
#  #Cloud Init Settings
#  ipconfig0    = "ip=192.168.${var.k3server.vlan}.${var.k3server.ip[count.index]}/24,gw=192.168.10.1"
#  searchdomain = "durp.loc"
#  nameserver   = var.dnsserver
#}
