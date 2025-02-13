#!/bin/bash

terraform init
source .env

# Define Cloudflare authentication variables
CF_EMAIL=$TF_VAR_cf_account_email
CF_API_KEY=$TF_VAR_cf_global_api_key
CF_TOKEN=$TF_VAR_cf_auth_token
CF_ZONE_ID=$TF_VAR_cf_zone_id
CF_ACCOUNT_ID=$TF_VAR_cf_account_id

# List of Cloudflare resource types
resources=(
  "cloudflare_access_application"
  "cloudflare_access_group"
  "cloudflare_access_mutual_tls_certificate"
  "cloudflare_access_policy"
  "cloudflare_access_rule"
  "cloudflare_access_service_token"
  "cloudflare_account_member"
  "cloudflare_api_shield"
  "cloudflare_argo"
  "cloudflare_authenticated_origin_pulls_certificate"
  "cloudflare_bot_management"
  "cloudflare_byo_ip_prefix"
  "cloudflare_certificate_pack"
  "cloudflare_custom_hostname"
  "cloudflare_custom_hostname_fallback_origin"
  "cloudflare_custom_pages"
  "cloudflare_custom_ssl"
  "cloudflare_filter"
  "cloudflare_firewall_rule"
  "cloudflare_healthcheck"
  "cloudflare_ip_list"
  "cloudflare_list"
  "cloudflare_load_balancer"
  "cloudflare_load_balancer_monitor"
  "cloudflare_load_balancer_pool"
  "cloudflare_logpull_retention"
  "cloudflare_logpush_job"
  "cloudflare_logpush_ownership_challenge"
  "cloudflare_magic_firewall_ruleset"
  "cloudflare_origin_ca_certificate"
  "cloudflare_page_rule"
  "cloudflare_rate_limit"
  "cloudflare_record"
  "cloudflare_ruleset"
  "cloudflare_spectrum_application"
  "cloudflare_tiered_cache"
  "cloudflare_teams_list"
  "cloudflare_teams_location"
  "cloudflare_teams_proxy_endpoint"
  "cloudflare_teams_rule"
  "cloudflare_tunnel"
  "cloudflare_turnstile_widget"
  "cloudflare_url_normalization_settings"
  "cloudflare_waf_group"
  "cloudflare_waf_override"
  "cloudflare_waf_package"
  "cloudflare_waf_rule"
  "cloudflare_waiting_room"
  "cloudflare_worker_cron_trigger"
  "cloudflare_worker_route"
  "cloudflare_worker_script"
  "cloudflare_workers_kv"
  "cloudflare_workers_kv_namespace"
  "cloudflare_zone"
  "cloudflare_zone_dnssec"
  "cloudflare_email_routing_dns"
  "cloudflare_zone_dns_records"
  "cloudflare_email_routing_rule"
  "cloudflare_zone_lockdown"
  "cloudflare_zone_settings_override"
  "cloudflare_zero_trust_gateway_policy"
  "cloudflare_zero_trust_dns_location"
  "cloudflare_zero_trust_access_group"
  "cloudflare_zero_trust_tunnel_cloudflared"
)

# Loop through each resource and run cf-terraforming generate and cf-terraforming import
for resource in "${resources[@]}"
do
  # Generate import file for each resource type
  echo "Generating Terraform configuration for ${resource}..."
  terraform_output=$(cf-terraforming generate --modern-import-block --account $CF_ACCOUNT_ID --email $CF_EMAIL --token $CF_TOKEN --key $CF_API_KEY --zone $CF_ZONE_ID --resource-type "$resource")

  # Check if output is not empty before creating the file
  if [ -n "$terraform_output" ]; then
    echo "$terraform_output" > "${resource}.tf"
    echo "Generated Terraform configuration for ${resource}"
  else
    echo "No output generated for ${resource}. Skipping file creation."
  fi

  # Generate import command for each resource type
  echo "Generating Terraform import commands for ${resource}..."
  import_output=$(cf-terraforming import --modern-import-block --account $CF_ACCOUNT_ID --email $CF_EMAIL --token $CF_TOKEN --key $CF_API_KEY --zone $CF_ZONE_ID --resource-type "$resource")

  # Check if output is not empty before creating the file
  if [ -n "$import_output" ]; then
    echo "$import_output" > "${resource}-import_cmds.txt"
    echo "Generated Terraform import command for ${resource}"
  else
    echo "No import command generated for ${resource}. Skipping file creation."
  fi

  # Add a delay between iterations if needed (optional)
  echo "Waiting before processing next resource..."
  sleep 2
done

echo "Terraform configuration generation and import command creation completed."