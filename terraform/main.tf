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

resource "proxmox_vm_qemu" "VM" {
  count       = var.k3master.count
  ciuser      = "administrator"
  vmid        = "20${var.k3master.ip[count.index]}"
  name        = var.k3master.name[count.index]
  target_node = var.k3master.node[count.index]
  clone       = var.k3master.template[count.index]
  qemu_os     = "other"
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
  ipconfig0    = "ip=192.168.20.${var.k3master.ip[count.index]}/24,gw=192.168.20.1"
  searchdomain = "durp.loc"
  nameserver   = var.dnsserver
  sshkeys      = var.sshkeys
}
