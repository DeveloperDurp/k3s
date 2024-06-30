locals {
  env_config = {
    prd = {
      dnsserver = "192.168.11.1"
      tags      = "k3s_prd"
      vlan      = 11
      k3master = {
        count  = 1
        name   = ["master-prd"]
        cores  = 4
        memory = "4096"
        drive  = 20
        node   = ["overlord"]
        ip     = ["10"]
      }
      k3server = {
        count  = 2
        name   = ["node01-prd", "node02-prd"]
        cores  = 4
        memory = "4096"
        drive  = 80
        node   = ["mothership", "mothership"]
        ip     = ["20", "21"]
      }
    }
    dev = {
      dnsserver = "192.168.10.1"
      tags      = "k3s_dev"
      vlan      = 10
      k3master = {
        count  = 1
        name   = ["master-dev"]
        cores  = 4
        memory = "4096"
        drive  = 20
        node   = ["overlord"]
        ip     = ["10"]
      }
      k3server = {
        count  = 2
        name   = ["node01-dev", "node02-dev"]
        cores  = 4
        memory = "4096"
        drive  = 60
        node   = ["mothership", "mothership"]
        ip     = ["20", "21"]
      }
    }
    default = {
      sshkeys    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL88nWIyxN4aYTJCxz2/MiorLeNtoVwir995tOXzdzCr laptop"
      template   = "Debian12-Template"
      storage    = "cache-domains"
      emulatessd = true
      format     = "raw"
    }
  }
}

resource "proxmox_vm_qemu" "k3master" {
  count       = local.config.k3master.count
  ciuser      = "administrator"
  vmid        = "${local.config.vlan}${local.config.k3master.ip[count.index]}"
  name        = local.config.k3master.name[count.index]
  target_node = local.config.k3master.node[count.index]
  clone       = local.config.template
  tags        = local.config.tags
  qemu_os     = "l26"
  full_clone  = true
  os_type     = "cloud-init"
  agent       = 1
  cores       = local.config.k3master.cores
  sockets     = 1
  cpu         = "host"
  memory      = local.config.k3master.memory
  scsihw      = "virtio-scsi-pci"
  #bootdisk    = "scsi0"
  boot    = "order=virtio0"
  onboot  = true
  sshkeys = local.config.sshkeys
  disks {
    ide {
      ide2 {
        cloudinit {
          storage = local.config.storage
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          size    = local.config.k3master.drive
          format  = local.config.format
          storage = local.config.storage
        }
      }
    }
  }
  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = local.config.vlan
  }
  #Cloud Init Settings
  ipconfig0    = "ip=192.168.${local.config.vlan}.${local.config.k3master.ip[count.index]}/24,gw=${local.config.dnsserver}"
  searchdomain = "durp.loc"
  nameserver   = local.config.dnsserver
}

resource "proxmox_vm_qemu" "k3server" {
  count       = local.config.k3server.count
  ciuser      = "administrator"
  vmid        = "${local.config.vlan}${local.config.k3server.ip[count.index]}"
  name        = local.config.k3server.name[count.index]
  target_node = local.config.k3server.node[count.index]
  clone       = local.config.template
  tags        = local.config.tags
  qemu_os     = "l26"
  full_clone  = true
  os_type     = "cloud-init"
  agent       = 1
  cores       = local.config.k3server.cores
  sockets     = 1
  cpu         = "host"
  memory      = local.config.k3server.memory
  scsihw      = "virtio-scsi-pci"
  #bootdisk    = "scsi0"
  boot    = "order=virtio0"
  onboot  = true
  sshkeys = local.config.sshkeys
  disks {
    ide {
      ide2 {
        cloudinit {
          storage = local.config.storage
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          size    = local.config.k3server.drive
          format  = local.config.format
          storage = local.config.storage
        }
      }
    }
  }
  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = local.config.vlan
  }
  #Cloud Init Settings
  ipconfig0    = "ip=192.168.${local.config.vlan}.${local.config.k3server.ip[count.index]}/24,gw=${local.config.dnsserver}"
  searchdomain = "durp.loc"
  nameserver   = local.config.dnsserver
}
