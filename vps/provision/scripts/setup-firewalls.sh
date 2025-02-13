#!/bin/bash

# set script to fail on errors
set -euo pipefile

# update and upgrade the system
update_system() {
    echo "Updating and upgrading system..."
    sudo dnf update --refresh -y
    sudo dnf upgrade -y
    sudo dnf clean all
}

setup_ufw() {
  # install UFW if not already installed
    if ! rpm -q ufw; then
        echo "UFW not installed. Installing..."
        sudo dnf install -y ufw
    else
        echo "UFW already installed:"
        ufw --version
    fi

    # apply rules from ufw.config file
    echo "Applying UFW rules..."
    sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/eileectrxity/vps/main/scripts/ufw.conf)" || { echo "Failed to download UFW config file. Exiting."; exit 1; }

    # enable and start UFW service
    echo "Enabling and starting UFW service..."
    sudo systemctl enable ufw
    sudo systemctl start ufw

    # reload UFW to ensure rules are applied
    echo "Reloading UFW to apply rules..."
    sudo ufw reload || { echo "Failed to reload UFW. Exiting."; exit 1; }

    # confirming firewall-level status to see current UFW rules in effect
    sudo ufw status verbose || { echo "Failed to start UFW. Exiting."; exit 1; }
}

# function to install and configure Fail2Ban
setup_fail2ban() {
    # install Fail2Ban if not already installed
    if ! rpm -q fail2ban; then
        echo "Fail2Ban not installed. Installing..."
        sudo dnf install -y fail2ban
    else
        echo "Fail2Ban already installed:"
        fail2ban --version
    fi

    # apply Fail2Ban jails from fail2ban.config file
    echo "Applying Fail2Ban configuration..."
    sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/eileectrxity/vps/main/scripts/fail2ban-jail.conf)" || { echo "Failed to download Fail2Ban config. Exiting."; exit 1; }

    # enable and start Fail2Ban service
    echo "Enabling and starting Fail2Ban service..."
    sudo systemctl enable fail2ban
    sudo systemctl start fail2ban

    # restart Fail2Ban to apply the configuration
    echo "Restarting Fail2Ban to apply configuration..."
    sudo systemctl restart fail2ban || { echo "Failed to restart Fail2Ban. Exiting."; exit 1; }
}

# ensuring UFW and Fail2Ban processes are active
check_service_status() {
    echo "Checking the status of services..."
    systemctl status ufw | grep "active (running)" || echo "UFW is not active."
    systemctl status fail2ban | grep "active (running)" || echo "Fail2Ban is not active."
}

# main
echo "Starting host firewall and network setup..."
update_system
setup_ufw
setup_fail2ban
check_service_status
echo "Host network setup complete with UFW and Fail2Ban."