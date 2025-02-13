#!/bin/bash

cd vps/provision/terraform

# Define a function to execute the curl command and check if it succeeded
run_curl() {
    echo "Running: $1"
    if ! sudo bash -c "$(curl -fsSL $1)"; then
        echo "Error: Failed to execute $1"
        exit 1
    else
        echo "Success: Executed $1"
    fi
}

# Load environment secrets
run_curl "https://raw.githubusercontent.com/eileectrxity/vps/main/scripts/load-env-secrets.sh"

# Install Virtualmin
run_curl "https://software.virtualmin.com/gpl/scripts/virtualmin-install.sh -- --minimal --verbose"

# Install Coolify
run_curl "https://cdn.coollabs.io/coolify/install.sh"

# Configure SSHD
run_curl "https://raw.githubusercontent.com/eileectrxity/vps/main/scripts/configure-sshd.sh"

# Setup Firewalls
run_curl "https://raw.githubusercontent.com/eileectrxity/vps/main/scripts/setup-firewalls.sh"

# Initialize Containers
run_curl "https://raw.githubusercontent.com/eileectrxity/vps/main/scripts/init-containers.sh"

echo "Automation Complete"



or

#!/bin/bash

# Set number of retries
MAX_RETRIES=3
RETRY_DELAY=5  # Time in seconds between retries

# Define a function to execute the curl command with retry logic
run_curl_with_retry() {
    local url=$1
    local retries=0

    while [ $retries -lt $MAX_RETRIES ]; do
        echo "Attempting to run: $url (Attempt #$((retries + 1)))"
        if sudo bash -c "$(curl -fsSL $url)"; then
            echo "Success: Executed $url"
            return 0  # Success
        else
            echo "Error: Failed to execute $url. Retrying in $RETRY_DELAY seconds..."
            retries=$((retries + 1))
            sleep $RETRY_DELAY
        fi
    done

    echo "Error: Failed to execute $url after $MAX_RETRIES attempts."
    return 1  # Failure
}

# Run each script with retry logic
run_curl_with_retry "https://raw.githubusercontent.com/eileectrxity/vps/main/scripts/load-env-secrets.sh" || { echo "Failed to load environment secrets. Exiting."; exit 1; }

run_curl_with_retry "https://software.virtualmin.com/gpl/scripts/virtualmin-install.sh -- --minimal --verbose" || { echo "Failed to install Virtualmin. Exiting."; exit 1; }

run_curl_with_retry "https://cdn.coollabs.io/coolify/install.sh" || { echo "Failed to install Coolify. Exiting."; exit 1; }

run_curl_with_retry "https://raw.githubusercontent.com/eileectrxity/vps/main/scripts/configure-sshd.sh" || { echo "Failed to configure SSHD. Exiting."; exit 1; }

run_curl_with_retry "https://raw.githubusercontent.com/eileectrxity/vps/main/scripts/setup-firewalls.sh" || { echo "Failed to setup firewall. Exiting."; exit 1; }

run_curl_with_retry "https://raw.githubusercontent.com/eileectrxity/vps/main/scripts/init-containers.sh" || { echo "Failed to initialize containers. Exiting."; exit 1; }

echo "Automation Complete"
