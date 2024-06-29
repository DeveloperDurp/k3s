locals {
  env_config = {
    prd = {
      dnsserver = "192.168.11.1"
      k3master = {
        count    = 1
        name     = ["master-prd"]
        cores    = 4
        memory   = "4096"
        drive    = "20G"
        storage  = "cache-domains"
        template = ["Debian12-Template"]
        node     = ["overlord"]
        ip       = ["10"]
        vlan     = 11
      }
      k3server = {
        count    = 2
        name     = ["node01-prd", "node02-prd"]
        cores    = 4
        memory   = "4096"
        drive    = "60G"
        storage  = "cache-domains"
        template = ["Debian12-Template", "Debian12-Template"]
        node     = ["mothership", "mothership"]
        ip       = ["20", "21"]
        vlan     = 11
      }
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
  disks {
    scsi {
      scsi0 {
        disk {
          size       = local.config.k3master.drive
          format     = "raw"
          storage    = local.config.k3master.storage
          emulatessd = true
        }
      }
    }
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

resource "proxmox_vm_qemu" "k3server" {
  count       = local.config.k3server.count
  ciuser      = "administrator"
  vmid        = "${local.config.k3server.vlan}${local.config.k3server.ip[count.index]}"
  name        = local.config.k3server.name[count.index]
  target_node = local.config.k3server.node[count.index]
  clone       = local.config.k3server.template[count.index]
  qemu_os     = "other"
  full_clone  = true
  os_type     = "cloud-init"
  agent       = 1
  cores       = local.config.k3server.cores
  sockets     = 1
  cpu         = "host"
  memory      = local.config.k3server.memory
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  boot        = "c"
  onboot      = true
  disks {
    scsi {
      scsi0 {
        disk {
          size       = local.config.k3master.drive
          format     = "raw"
          storage    = local.config.k3master.storage
          emulatessd = true
        }
      }
    }
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
  ipconfig0    = "ip=192.168.${local.config.k3server.vlan}.${local.config.k3server.ip[count.index]}/24,gw=192.168.10.1"
  searchdomain = "durp.loc"
  nameserver   = local.config.dnsserver
}
