#!/bin/bash

# set script to fail on errors
set -euo pipefail

# func to load environment variables from a local .env file
load_env_file() {
    if [ -f .env ]; then
        export $(grep -v '^#' .env | xargs) # exports env vars by filters out any comment lines (starting with #)
        echo ".env file loaded."
    else
        echo "No .env file found. Please create one."
    fi
}

# check if Vault is configured and attempt to fetch secrets
if [ ! -z "$VAULT_ADDR" ]; then
    echo "Vault is configured, attempting to fetch secrets..."
    VAULT_TOKEN="your-vault-token"  # ensure that your Vault token is configured
    SECRET_PATH="secret/my-app"     # update with your actual secret path
    SECRET=$(vault kv get -field=value $SECRET_PATH)
    export SECRET
    echo "Vault secrets loaded."
else
    echo "Vault is not configured, falling back to .env file."
    load_env_file
fi

# verifying env variables loaded
echo "Loaded environment variables:"
env
