# main.tf

#defines the infrastructure resources that tf will provision- note there are dependencies between resources which tf will automatically handle
terraform {
  # backend "remote" {        # configures terraform to use the remote/online backend with HCP Terraform for web-accessible state management
  #   organization = "tf-xln" # from your online tf account
  #   workspaces {
  #     name = "xln-vps"
  #   }
  # }
  required_providers {
    # core infrastructure providers
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.49"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.52"
    }
    # auxiliary providers
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.6"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3"
    }
  }
  required_version = ">= 1.10"
}

provider "hcloud" {
  token = var.hcloud_token # resources created will be automatically assigned to the project associated with your api token
}

provider "cloudflare" {
  api_token = var.cf_auth_token # retrieved from manual creation in cf account
}

provider "vault" {
  token   = var.vault_token
  address = var.vault_address
}