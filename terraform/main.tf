locals {
  env_config = {
    prd = {
      dnsserver = "192.168.11.1"
      tags      = "k3s_prd"
      vlan      = 11
      k3master = {
        count  = 3
        name   = ["master01-prd", "master02-prd", "master03-prd"]
        cores  = 2
        memory = "4096"
        drive  = 20
        node   = ["gatekeeper", "mothership", "overlord"]
        ip     = ["11", "12", "13"]
      }
      k3server = {
        count  = 3
        name   = ["node01-prd", "node02-prd", "node03-prd"]
        cores  = 4
        memory = "8192"
        drive  = 120
        node   = ["mothership", "mothership", "mothership"]
        ip     = ["21", "22", "23"]
      }
    }
    infra = {
      dnsserver = "192.168.12.1"
      tags      = "k3s_infra"
      vlan      = 12
      k3master = {
        count  = 3
        name   = ["master01-infra", "master02-infra", "master03-infra"]
        cores  = 2
        memory = "4096"
        drive  = 20
        node   = ["gatekeeper", "mothership", "overlord"]
        ip     = ["11", "12", "13"]
      }
      k3server = {
        count  = 3
        name   = ["node01-infra", "node02-infra", "node03-infra"]
        cores  = 4
        memory = "8192"
        drive  = 240
        node   = ["overlord", "overlord", "overlord"]
        ip     = ["21", "22", "23"]
      }
    }
    dev = {
      dnsserver = "192.168.10.1"
      tags      = "k3s_dev"
      vlan      = 10
      k3master = {
        count  = 3
        name   = ["master01-dev", "master02-dev", "master03-dev"]
        cores  = 2
        memory = "4096"
        drive  = 20
        node   = ["gatekeeper", "mothership", "overlord"]
        ip     = ["11", "12", "13"]
      }
      k3server = {
        count  = 3
        name   = ["node01-dev", "node02-dev", "node03-dev"]
        cores  = 4
        memory = "8192"
        drive  = 120
        node   = ["mothership", "mothership", "mothership"]
        ip     = ["21", "22", "23"]
      }
    }
    dmz = {
      dnsserver = "192.168.98.1"
      tags      = "k3s_dmz"
      vlan      = 98
      k3master = {
        count  = 3
        name   = ["master01-dmz", "master02-dmz", "master03-dmz"]
        cores  = 2
        memory = "4096"
        drive  = 20
        node   = ["gatekeeper", "mothership", "overlord"]
        ip     = ["11", "12", "13"]
      }
      k3server = {
        count  = 3
        name   = ["node01-dmz", "node02-dmz", "node03-dmz"]
        cores  = 4
        memory = "8192"
        drive  = 120
        node   = ["mothership", "mothership", "mothership"]
        ip     = ["21", "22", "23"]
      }
    }
    default = {
      sshkeys    = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDEphzWgwUZnvL6E5luKLt3WO0HK7Kh63arSMoNl5gmjzXyhG1DDW0OKfoIl0T+JZw/ZjQ7iii6tmSLFRk6nuYCldqe5GVcFxvTzX4/xGEioAyG0IiUGKy6s+9xzO8QXF0EtSNPH0nfHNKcCjgwWAzM+Lt6gW0Vqs+aU5ICuDiEchmvYPz+rBaVldJVTG7m3ogKJ2aIF7HU/pCPp5l0E9gMOw7s0ABijuc3KXLEWCYgL39jIST6pFH9ceRLmu8Xy5zXHAkkEEauY/e6ld0hlzLadiUD7zYJMdDcm0oRvenYcUlaUl9gS0569IpfsJsjCejuqOxCKzTHPJDOT0f9TbIqPXkGq3s9oEJGpQW+Z8g41BqRpjBCdBk+yv39bzKxlwlumDwqgx1WP8xxKavAWYNqNRG7sBhoWwtxYEOhKXoLNjBaeDRnO5OY5AQJvONWpuByyz0R/gTh4bOFVD+Y8WWlKbT4zfhnN70XvapRsbZiaGhJBPwByAMGg6XxSbC6xtbyligVGCEjCXbTLkeKq1w0DuItY+FBGO3J2k90OiciTVSeyiVz9J/Y03UB0gHdsMCoVNrj+9QWfrTLDhM7D5YrXUt5nj2LQTcbtf49zoQXWxUhozlg42E/FJU/Yla7y55qWizAEVyP2/Ks/PHrF679k59HNd2IJ/aicA9QnmWtLQ== ansible"
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
  cpu_type    = "host"
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
          storage = try(local.config.k3master.storage, local.config.storage)
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          size    = local.config.k3master.drive
          format  = local.config.format
          storage = try(local.config.k3master.storage, local.config.storage)
        }
      }
    }
  }
  network {
    id     = 0
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
  cpu_type    = "host"
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
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
    tag    = local.config.vlan
  }
  #Cloud Init Settings
  ipconfig0    = "ip=192.168.${local.config.vlan}.${local.config.k3server.ip[count.index]}/24,gw=${local.config.dnsserver}"
  searchdomain = "durp.loc"
  nameserver   = local.config.dnsserver
}
