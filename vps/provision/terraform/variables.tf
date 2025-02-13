# variables.tf

# # hashicorp vault
# variable "hcp_vault_api_token" {
#   description = "HashiCorp Vault API token"
#   type        = string
#   sensitive   = true
# }

# hetzner cloud
variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "hcloud_server_type" {
  description = "Hetzner Cloud server type"
  type        = string
  default     = "cx21" # shared vCPU AMD with 2 vCPU, 4GB RAM, 2TB traffic
}

variable "hcloud_location" {
  description = "Hetzner Cloud server location closest to you + your customers"
  type        = string
  default     = "ash" # us east (ashburn, virginia)
}

variable "vps_hostname" {
  description = "Hetzner Cloud VPS host username"
  type        = string
  default     = "admin"
}

# cloudflare
variable "cf_auth_token" {
  description = "Cloudflare API token"
  type        = string
  sensitive   = true
}

variable "cf_access_email" {
  description = "Email for Cloudflare Access"
  type        = string
  sensitive   = true
}

variable "cf_tunnel_token" {
  description = "Cloudflare tunnel token"
  type        = string
  sensitive   = true
}

variable "cf_account_id" {
  description = "Cloudflare account ID"
  type        = string
}

variable "vps_domain" {
  description = "The domain name for the VPS"
  type        = string
}

variable "cf_access_vps_name" {
  description = "Name of VPS access application"
  type        = string
  default     = "hcloud_vps"
}