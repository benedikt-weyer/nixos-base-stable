#!/usr/bin/env bash

# NixOS Hardware Configuration Setup Script
# This script generates the hardware configuration and places it in the correct location

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOSTS_DIR="$SCRIPT_DIR/hosts/default"
HARDWARE_CONFIG_PATH="$HOSTS_DIR/hardware-configuration.nix"

echo -e "${BLUE}NixOS Hardware Configuration Setup${NC}"
echo "======================================="

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    echo -e "${RED}Error: This script should not be run as root.${NC}"
    echo "Please run as a regular user with sudo privileges."
    exit 1
fi

# Check if nixos-generate-config exists
if ! command -v nixos-generate-config &> /dev/null; then
    echo -e "${RED}Error: nixos-generate-config command not found.${NC}"
    echo "This script must be run on a NixOS system."
    exit 1
fi

# Check if flakes are available (either globally enabled or can be enabled temporarily)
echo -e "${BLUE}Checking Nix flakes availability...${NC}"
if nix flake --help &> /dev/null; then
    echo -e "${GREEN}Flakes are globally enabled.${NC}"
    FLAKE_ENABLED=true
    NIX_REBUILD_CMD="sudo nixos-rebuild"
elif nix --extra-experimental-features "flakes nix-command" flake --help &> /dev/null 2>&1; then
    echo -e "${YELLOW}Flakes are not globally enabled, but can be used temporarily.${NC}"
    echo "Will use --extra-experimental-features for nixos-rebuild commands."
    FLAKE_ENABLED=false
    NIX_REBUILD_CMD="sudo nixos-rebuild --extra-experimental-features 'flakes nix-command'"
else
    echo -e "${RED}Error: Nix flakes are not available on this system.${NC}"
    echo ""
    echo "To enable flakes globally, add the following to your /etc/nixos/configuration.nix:"
    echo ""
    echo "  nix.settings.experimental-features = [ \"nix-command\" \"flakes\" ];"
    echo ""
    echo "Then run: sudo nixos-rebuild switch"
    echo ""
    echo "Alternatively, you can use flakes temporarily with --extra-experimental-features."
    exit 1
fi

# Check if hosts/default directory exists
if [[ ! -d "$HOSTS_DIR" ]]; then
    echo -e "${RED}Error: Directory $HOSTS_DIR does not exist.${NC}"
    echo "Please make sure you're running this script from the nixos-base-stable directory."
    exit 1
fi

# Backup existing hardware-configuration.nix if it exists
if [[ -f "$HARDWARE_CONFIG_PATH" ]]; then
    BACKUP_PATH="${HARDWARE_CONFIG_PATH}.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${YELLOW}Warning: hardware-configuration.nix already exists.${NC}"
    echo "Creating backup at: $BACKUP_PATH"
    cp "$HARDWARE_CONFIG_PATH" "$BACKUP_PATH"
fi

echo -e "${BLUE}Generating hardware configuration...${NC}"

# Create a temporary directory for hardware configuration generation
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# Generate hardware configuration in temporary directory
echo "Running: sudo nixos-generate-config --dir $TEMP_DIR"
if sudo nixos-generate-config --dir "$TEMP_DIR"; then
    echo -e "${GREEN}Hardware configuration generated successfully.${NC}"
else
    echo -e "${RED}Error: Failed to generate hardware configuration.${NC}"
    exit 1
fi

# Copy hardware-configuration.nix to the correct location
if [[ -f "$TEMP_DIR/hardware-configuration.nix" ]]; then
    cp "$TEMP_DIR/hardware-configuration.nix" "$HARDWARE_CONFIG_PATH"
    echo -e "${GREEN}Hardware configuration copied to: $HARDWARE_CONFIG_PATH${NC}"
else
    echo -e "${RED}Error: Generated hardware-configuration.nix not found.${NC}"
    exit 1
fi

# Set proper permissions
chmod 644 "$HARDWARE_CONFIG_PATH"

echo ""
echo -e "${GREEN}Setup completed successfully!${NC}"
echo ""
echo "Next steps:"
echo "1. Review the generated hardware-configuration.nix file:"
echo "   cat $HARDWARE_CONFIG_PATH"
echo ""
echo "2. Add the generated files to git (required for flakes):"
echo "   git add ."
echo ""
echo "3. Apply your configuration:"
if [[ "$FLAKE_ENABLED" == true ]]; then
    echo "   sudo nixos-rebuild switch --flake .#default"
else
    echo "   sudo nixos-rebuild switch --extra-experimental-features 'flakes nix-command' --flake .#default"
fi
echo ""
echo -e "${BLUE}Note: The hardware-configuration.nix file is now in the correct location${NC}"
echo -e "${BLUE}and will be automatically imported by your configuration.nix file.${NC}"
