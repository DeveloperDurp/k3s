variable "pm_api_url" {
    description = "API URL to Proxmox provider"
    type = string
}

variable "dnsserver" {
    description = "DNS provider"
    type = string
}

variable "sshkeys" {
    description = "Public SSH key to inject into CloudInit"
    type = string
}

variable "pm_password" {
    description = "Passowrd to Proxmox provider"
    type = string
}

variable "pm_user" {
    description = "UIsername to Proxmox provider"
    type = string
    default = "root@pam"
}


variable "k3master" {
    description = "Defaults of master nodes in K3S"
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
    default = {
        count    = "1"
        name     = ["master01"]
        cores    = "2"
        memory   = "2048"
        drive    = "20G"
        storage  = "domains"
        template = "CentOS9-Template"
        node     = "overlord"
        tag      = "20"
        ip       = ["121"]
    }
}

variable "k3server" {
    description = "Defaults of worker nodes in K3S"
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
        default = {
        count    = "1"
        name     = ["node01"]
        cores    = "2"
        memory   = "4096"
        drive    = "60G"
        storage  = "domains"
        template = "CentOS9-Template"
        node     = "overlord"
        tag      = "20"
        ip       = ["124"]
    }
}
