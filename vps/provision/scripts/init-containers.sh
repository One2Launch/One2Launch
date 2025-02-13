#!/bin/bash

# set script to fail on errors
set -euo pipefile

# ensure that Docker is installed (note: Docker Engine now includes Docker Compose)
setup_docker() {
    if ! docker --version &> /dev/null; then
        echo "Docker is not installed. Installing Docker..."
        sudo dnf install yum-utils -y
        sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        sudo dnf install docker-ce containerd.io -y
        sudo systemctl enable docker
        sudo systemctl start docker
        echo "Docker Engine installed and started."
    else
        echo "Docker is already installed:"
        docker --version
    fi
}

# in case Docker Compose is not installed along with Docker Engine
setup_docker_compose() {
    if ! docker compose version &> /dev/null; then
        echo "Docker Compose is not installed. Installing Docker Compose..."
        sudo dnf install -y docker-compose-plugin
    else
        echo "Docker Compose is already installed:"
        docker compose version
    fi
}

start_containers() {
    # list of container directory paths
    declare -a app_dirs=("docker/cloudflared", "docker/traefik")

    # iterate through directories and start containers
    for app_dir in "${app_dirs[@]}"; do
        if [ -d "$app_dir" ]; then
            echo "Navigating to $app_dir..."
            cd "$app_dir" || { echo "Failed to cd into $app_dir. Skipping."; continue; }

            # ensure docker-compose.yml exists in the directory
            if [ ! -f "docker-compose.yml" ]; then
                echo "docker-compose.yml file is missing in $app_dir. Skipping."
                continue
            fi

            app_service=$(basename "$app_dir")
            echo "Pulling latest docker image for $app_service..."
            sudo docker compose pull || { echo "Failed to recreate container images for $app_service. Skipping."; continue; }

            echo "Starting Docker container for $app_service..."
            sudo docker compose up -d  # start container in detached mode

            echo "Verifying $app_service container is running..."
            if sudo docker ps --filter "name=$app_service" --format "{{.Names}}" | grep -q "$app_service"; then
                echo "$app_service is running."
            else
                echo "$app_service is NOT running! Check logs for errors."
            fi
        else
            echo "Error: Directory $app_dir does not exist. Skipping."
        fi
    done

    echo "All services have been started."
}

# main
echo "Starting docker process..."
setup_docker
setup_docker_compose
start_containers
echo "All containers initialized and running successfully."