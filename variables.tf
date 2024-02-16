variable "ssh_public_key_filepath" {
  description = "Filepath for ssh public key"
  type        = string

  default = "key.pub"
}

variable "gcp_zone" {
  description = "zona gcp"
  type = string

  default = "europe-central2-a" 
}

variable "gcp_machine_type" {
  description = "maszyna gcp - rozmiar"
  type = string

  default = "f1-micro" 
}

variable "vm_tag" {
  description = "tag maszyny"
  type= string

  default = "vm-instance"
}