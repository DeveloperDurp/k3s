#k3s
#-----------------------------------------------------

resource "proxmox_vm_qemu" "k3master" {
  count       = var.k3master.count
  ciuser      = "administrator"
  vmid        = "20${var.k3master.ip[count.index]}"
  name        = var.k3master.name[count.index]
  target_node = var.k3master.node[count.index]
  clone       = var.k3master.template[count.index]
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
    size    = var.k3master.drive[count.index]
    type    = "scsi"
    storage = var.k3master.storage
    ssd     = 1
    backup  = 0
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

resource "proxmox_vm_qemu" "k3server" {
  count       = var.k3server.count
  ciuser      = "administrator"
  vmid        = "20${var.k3server.ip[count.index]}"
  name        = var.k3server.name[count.index]
  target_node = var.k3server.node[count.index]
  clone       = var.k3server.template[count.index]
  full_clone  = true
  os_type     = "cloud-init"
  agent       = 1
  cores       = var.k3server.cores
  sockets     = 1
  cpu         = "host"
  memory      = var.k3server.memory
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  boot        = "c"
  onboot      = true
  disk {
    size    = var.k3server.drive[count.index]
    type    = "scsi"
    storage = var.k3server.storage
    ssd     = 1
    backup  = 0
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
  ipconfig0    = "ip=192.168.20.${var.k3server.ip[count.index]}/24,gw=192.168.20.1"
  searchdomain = "durp.loc"
  nameserver   = var.dnsserver
  sshkeys      = var.sshkeys
}
