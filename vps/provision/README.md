# Secure Linux VPS

Automates the deployment of a secure Hetzner VPS running Alma Linux, with Cloudflare Tunnel and Coolify for managing containerized applications and services including Docker, Virtualmin, Crowdsec, Grafana, Prometheus, Loki, and OpenTelemetry.

## Repository Structure
```plaintext
.
├── README.md
├── cloud-init               # Cloud-init configuration for initial VPS setup
│   └── cloud-config.yml
├── provisioning
│   ├── main.tf              # Terraform configuration to provision the Hetzner VPS
│   ├── variables.tf
│   ├── terraform.tfvars     # Terraform variable values
│   └── README.md            # Terraform setup guide
├── config                   # configurations for server services
│   ├── fail2ban-jail.conf
│   └── ufw.conf
├── docker
│   ├── authentik            # Authentication middleware
│   │   ├── README.md
│   │   └── docker-compose.yml
│   ├── cloudflared          # Cloudflare Zero Trust Tunnel service
│   │   ├── README.md
│   │   └── docker-compose.yml
│   ├── crowdsec             # Network security service
│   │   ├── README.md
│   │   └── docker-compose.yml
│   ├── grafana              # Monitoring and observability services
│   │   ├── README.md
│   │   ├── docker-compose.yml
│   │   ├── grafana.ini
│   │   └── services
│   │       ├── loki
│   │       │   └── docker-compose.yml
│   │       ├── opentelemetry
│   │       │   └── docker-compose.yml
│   │       └── prometheus
│   │           └── docker-compose.yml
│   └── traefik              # Reverse proxy middleware
│       ├── README.md
│       ├── docker-compose.yml
│       ├── fileConfig.yml
│       └── traefik.yml
└── scripts                  # Custom scripts for setup and configuration
    ├── configure-sshd.sh    # Hardens server SSHD security
    ├── init-containers.sh   # Initializes Docker containers
    └── setup-firewalls.sh   # Sets up UFW and Fail2Ban
```

## Prerequisites

- A **Hetzner Cloud account** for provisioning a VPS.
- A **Cloudflare account** to set up Cloudflare Tunnel and Zero Trust.
- A **domain name** for your Cloudflare Tunnel, Virtualmin, and Coolify.

## Setup Guide

### 1. Provision Your Hetzner VPS with Alma Linux

There are two ways to provision your Hetzner VPS:

#### **Recommended**: Provision Using Hetzner Cloud GUI
If you're looking for a quick and easy way to get started, the Hetzner Cloud Console (GUI) is the recommended approach. It allows for manual configuration and immediate control over your VPS instance.

**Steps**:

1. Create a new VPS instance in the [Hetzner Cloud Console](https://console.hetzner.cloud).
2. Select **Alma Linux** as the operating system for the VPS.
3. Configure your server with your desired specifications (CPU, RAM, disk size, etc.).
4. Set up **SSH key authentication** by adding your public SSH key during the VPS creation process.
5. Finish the setup, and you will have a fully provisioned VPS ready to go.

The Hetzner Cloud Console is ideal for users who prefer a GUI-based approach and are comfortable with manual configuration. It is also faster for one-off setups or small environments.

#### **Alternative**: Provision Using Terraform (For Automated Provisioning)
If you prefer automated provisioning and want to integrate this process into your workflows, Terraform is a great tool. It allows for consistent, repeatable infrastructure setups.

**Steps**:

1. Modify the `terraform.tfvars` file with your desired configurations, including your Hetzner API key, server details, and region.
2. Run the following commands to initialize and apply the Terraform configuration:

    ```bash
    terraform init
    terraform apply
    ```

This will initialize the Terraform project and apply the configuration to provision the VPS automatically.

While using the Hetzner Cloud GUI is faster for manual setups, **Terraform setup included** for those interested in learning automated provisioning or those who need consistent, repeatable deployments across multiple environments.

### 2. Update Env Variables

After provisioning your VPS, configure the `cloud-init` settings to ensure the initial setup is automated:

1. Update the following values in the `cloud-init/cloud-config.yml` file:
    - Set `<vps-username>` to your desired username (e.g., `admin`).
    - Set `<hashed-paswd-for-sudo-user>` to your desired sudo password (hashed, for better security).
    - Replace `<your-ssh-public-key>` with your SSH public key for secure access to the server.

This cloud-init configuration will help automate the setup of your VPS and ensure secure access.

2. Update variable values in `.env.cloudflared` file

### 3. Deploy Cloud-init Configuration

After modifying the cloud-init file, add it to your Hetzner VPS configuration:

- If you're using Terraform, this will be applied automatically during the provisioning process.
- If you're using the Hetzner Cloud GUI, upload the `cloud-config.yml` file during the VPS creation process (usually in the "User Data" section).

This step ensures that your VPS is configured correctly from the moment it is provisioned.

### 4. Verify Services

After provisioning the VPS and applying the cloud-init configuration:

1. SSH into the server using the credentials you set up.
2. Verify that all services are working (e.g., Docker, Cloudflare Tunnel, etc.).

## Best Practices

- **Containerization**: All services are containerized using Docker to ensure easy deployment and isolation.
- **Least Privilege**: Only expose necessary services and ports to the internet. Use firewalls and security groups to restrict access.
- **Automation**: Use Cloud-init, Docker Compose, and custom scripts for seamless provisioning and management.
- **Observability**: Set up monitoring tools (Prometheus, Grafana) and logging tools (Loki, OpenTelemetry) for enhanced visibility into your infrastructure.

## Credits

- Shoutout to [Haxxnet's Compose-Examples](https://github.com/Haxxnet/Compose-Examples) for their awesome Docker Compose examples, which served as inspiration for many of the containerized services in this repo!

