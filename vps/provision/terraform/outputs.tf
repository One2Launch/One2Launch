output "server_ipv4" {
  value       = hcloud_server.alma_vps.ipv4_address
  description = "The public IP address of the Hetzner VPS. Used for confirming VPS creation and direct access."
}

output "server_ipv6" {
  value       = hcloud_server.alma_vps.ipv6_address
  description = "The public IP address of the Hetzner VPS. Used for confirming VPS creation and direct access."
}

output "vps_cname" {
  value       = cloudflare_record.vps_cname.hostname
  description = "The DNS CNAME entry for the VPS, used to reference the VPS via its Cloudflare tunnel instead of its IP."
}

output "tf_managed_vps_zone_id" {
  value       = cloudflare_zone.tf_managed_vps_zone.id
  description = "The Cloudflare Zone ID for the VPS domain, necessary for managing DNS settings and applying Cloudflare security."
}

output "cloudflared_tunnel_id" {
  value       = cloudflare_zero_trust_tunnel_cloudflared.vps_tunnel.id
  description = "The Cloudflare Zero Trust Tunnel ID, used to route traffic securely from Cloudflare to your Hetzner VPS."
}

output "vps_access_application_id" {
  value       = cloudflare_zero_trust_access_application.vps_access.id
  description = "The Cloudflare Zero Trust Access Application ID for the VPS, linking your app to policies and security groups."
}

output "cf_zone_id" {
  value       = cloudflare_zone.tf_managed_vps_zone.id
  description = "Cloudflare Zone ID, used for managing DNS settings and applying Cloudflare security features to your domain."
}

output "cf_app_aud" {
  value       = cloudflare_zero_trust_access_application.vps_access.aud
  description = "The Cloudflare Zero Trust Access Application Audience ID, used to define authentication policies for users."
}

output "cf_app_id" {
  value       = cloudflare_zero_trust_access_application.vps_access.id
  description = "The Cloudflare Zero Trust Access Application ID, used to uniquely identify the application in Cloudflare Access."
}

output "cf_access_group_id" {
  value       = cloudflare_zero_trust_access_group.admin_group.id
  description = "The ID for the Cloudflare Access Group controlling admin access to your application."
}

output "cf_access_policy_id" {
  value       = cloudflare_zero_trust_access_policy.admin_policy.id
  description = "The Cloudflare Zero Trust Access Policy ID for the admin group, defining access rules and security conditions."
}

output "cf_tunnel_id" {
  value       = cloudflare_zero_trust_tunnel_cloudflared.vps_tunnel.id
  description = "The Cloudflare Zero Trust Tunnel ID representing the specific tunnel connection used to route traffic securely from Cloudflare to your Hetzner VPS, enabling access to the server's web apps."
}

output "firewall_id" {
  value       = hcloud_firewall.basic_firewall.id
  description = "The Hetzner firewall ID, used to manage network-side security settings for the server."
}
