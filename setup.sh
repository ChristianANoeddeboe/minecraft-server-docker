#!/bin/bash

setup_mods() {
    # Create mods directory
    mkdir -p /var/minecraft/mods

    # Download latest Fabric API for 1.21.4 if it doesn't already exist
    if [ ! -f /var/minecraft/mods/fabric-api.jar ]; then
        FABRIC_VERSION=$(curl -sH "Accept: application/vnd.github+json" "https://api.github.com/repos/FabricMC/fabric/releases" | jq \
            -r '.[] | select(.tag_name | contains("1.21.4")) | .tag_name' | head -n1)
        curl -L -o /var/minecraft/mods/fabric-api.jar "https://github.com/FabricMC/fabric/releases/download/${FABRIC_VERSION}/fabric-api-${FABRIC_VERSION}.jar"
    fi
}

main() {
    setup_mods
    # Add other setup tasks here
}

main "$@"
