# cloudflare.tf

# cf dns
resource "cloudflare_zone" "tf_managed_vps_zone" {
  account_id = var.cf_account_id # account id of specific cf managed domain name
  zone       = var.vps_domain
  paused     = false
  plan       = "free"
  type       = "full"
  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_record" "vps_cname" {
  zone_id = cloudflare_zone.tf_managed_vps_zone.id
  name    = "*.${cloudflare_zone.tf_managed_vps_zone.zone}"           # making vps accessible over wildcard.our-vps-domain-name.com (any subdomain)
  content = cloudflare_zero_trust_tunnel_cloudflared.vps_tunnel.cname # pointing to the tunnel instead of vps ip address
  type    = "CNAME"
  proxied = true # traffic protected by cf servers through cf tunnel
  lifecycle {
    prevent_destroy = true
  }
}

# cf zero trust tunnel
resource "cloudflare_zero_trust_tunnel_cloudflared" "vps_tunnel" {
  account_id = cloudflare_zone.tf_managed_vps_zone.account_id
  name       = var.cf_access_vps_name
  secret     = var.cf_tunnel_token
  lifecycle {
    prevent_destroy = true
  }
}

# configuring cf tunnel route (to forward traffic to vps
resource "cloudflare_zero_trust_tunnel_cloudflared_config" "vps_tunnel_config" {
  account_id = cloudflare_zone.tf_managed_vps_zone.account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.vps_tunnel.id

  config {
    ingress_rule {
      hostname = "virtualmin.${cloudflare_zone.tf_managed_vps_zone.zone}" # subdomain to route traffic through
      service  = "http://traefik:80"                                      # traefik listens on port 80 internally in the Docker container
      origin_request {
        connect_timeout          = "2m0s"
        disable_chunked_encoding = false
        http2_origin             = false
        keep_alive_connections   = 100
        keep_alive_timeout       = "1m30s"
        no_happy_eyeballs        = false
        no_tls_verify            = false
        proxy_address            = "127.0.0.1"
        proxy_port               = 0
        tcp_keep_alive           = "30s"
        tls_timeout              = "10s"
        access {
          aud_tag   = [cloudflare_zero_trust_access_application.vps_access.aud]
          required  = true
          team_name = cloudflare_zero_trust_access_group.admin_group.name
        }
      }
    }
  }
  lifecycle {
    prevent_destroy = true
  }
}

# cf zero trust access
resource "cloudflare_zero_trust_access_application" "vps_access" {
  account_id                   = cloudflare_zone.tf_managed_vps_zone.account_id
  allow_authenticate_via_warp  = false
  allowed_idps                 = []
  app_launcher_logo_url        = null
  app_launcher_visible         = true
  auto_redirect_to_identity    = false
  bg_color                     = null
  custom_deny_message          = null
  custom_deny_url              = null
  custom_non_identity_deny_url = null
  custom_pages                 = []
  domain                       = null
  enable_binding_cookie        = false
  header_bg_color              = null
  http_only_cookie_attribute   = false
  logo_url                     = null
  name                         = cloudflare_zero_trust_tunnel_cloudflared.vps_tunnel.name
  options_preflight_bypass     = false
  same_site_cookie_attribute   = null
  service_auth_401_redirect    = false
  session_duration             = "6h"
  skip_app_launcher_login_page = false
  skip_interstitial            = false
  tags                         = []
  type                         = "self_hosted"
  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_zero_trust_access_group" "admin_group" {
  account_id = cloudflare_zone.tf_managed_vps_zone.account_id
  name       = "admin"

  include {
    any_valid_service_token = false
    auth_method             = null
    certificate             = false
    common_name             = null
    common_names            = []
    device_posture          = []
    email                   = []
    email_domain            = []
    email_list              = []
    everyone                = false
    geo                     = ["US"]
    group                   = []
    ip                      = []
    ip_list                 = []
    login_method            = []
    service_token           = []
  }

  require {
    any_valid_service_token = false
    auth_method             = "mfa"
    certificate             = false
    common_name             = null
    common_names            = []
    device_posture          = []
    email                   = [var.cf_access_email]
    email_domain            = []
    email_list              = []
    everyone                = false
    geo                     = []
    group                   = []
    ip                      = []
    ip_list                 = []
    login_method            = []
    service_token           = []
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_zero_trust_access_policy" "admin_policy" {
  account_id                     = cloudflare_zone.tf_managed_vps_zone.account_id
  application_id                 = cloudflare_zero_trust_access_application.vps_access.id
  approval_required              = false
  decision                       = "allow"
  isolation_required             = false
  name                           = cloudflare_zero_trust_access_group.admin_group.name
  precedence                     = 1
  purpose_justification_prompt   = null
  purpose_justification_required = false
  session_duration               = "6h"

  include {
    any_valid_service_token = false
    auth_method             = null
    certificate             = false
    common_name             = null
    common_names            = []
    device_posture          = []
    email                   = []
    email_domain            = []
    email_list              = []
    everyone                = false
    geo                     = []
    group                   = [cloudflare_zero_trust_access_group.admin_group.id]
    ip                      = []
    ip_list                 = []
    login_method            = []
    service_token           = []
  }

  require {
    any_valid_service_token = false
    auth_method             = "mfa"
    certificate             = false
    common_name             = null
    common_names            = []
    device_posture          = []
    email                   = []
    email_domain            = []
    email_list              = []
    everyone                = false
    geo                     = ["US"]
    group                   = []
    ip                      = []
    ip_list                 = []
    login_method            = []
    service_token           = []
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_zero_trust_gateway_policy" "terraform_managed_resource_04010e41-fca0-4eeb-a26e-cfa29befaa8a" {
  account_id  = cloudflare_zone.tf_managed_vps_zone.account_id
  action      = "block"
  description = "default"
  enabled     = true
  filters     = ["dns"]
  name        = "Block Malware"
  precedence  = 9000
  traffic     = "any(dns.security_category[*] in {117})"
  rule_settings {
    block_page_enabled                 = false
    insecure_disable_dnssec_validation = false
    ip_categories                      = false
  }
}

# cf waf rules
resource "cloudflare_ruleset" "https_only" {
  description = "Force all incoming traffic to use HTTPS"
  kind        = "managed"
  name        = "HTTPS Only"
  phase       = "http_request_redirect"
  zone_id     = cloudflare_zone.tf_managed_vps_zone.id

  rules {
    action      = "redirect"
    description = "Redirect HTTP requests to HTTPS"
    enabled     = true
    expression  = "http.request.scheme eq \"http\""

    action_parameters {
      response {
        content_type = "text/html"
        status_code  = 301
      }
    }
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_ruleset" "waf_managed" {
  kind  = "managed"
  name  = "WAF Managed"
  phase = "http_request_firewall_managed"

  rules {
    action      = "challenge" # forcing bot traffic to solve a captcha challenge
    description = "Challenge suspicious traffic"
    enabled     = true
    expression  = "cf.client.bot eq true" # applying ruleset to traffic that cf has identified as potential bots
  }

  zone_id     = cloudflare_zone.tf_managed_vps_zone.id
  description = "Cloudflare WAF Managed Rules"
  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_ruleset" "rate_limit" {
  kind  = "managed"
  name  = "Rate Limiting"
  phase = "http_ratelimit"

  rules {
    action      = "block"
    description = "Block excessive requests"
    enabled     = true
    expression  = "cf.threat_score gt 50" # applying ruleset to traffic with a threat score of 30+

    action_parameters {
      response {
        content      = "Too many requests"
        content_type = "text/html"
        status_code  = 429
      }
    }
  }
  zone_id     = cloudflare_zone.tf_managed_vps_zone.id
  description = "Rate Limiting to prevent abuse or DDoS attacks"
  lifecycle {
    prevent_destroy = true
  }
}
