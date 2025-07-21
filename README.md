# nixos-base-stable

A NixOS configuration template for testing and debugging purposes, using the latest stable NixOS channel.

## Quick Setup

### 1. Clone the Repository

If you don't have git installed, you can temporarily install it using nix-shell:

```bash
# If git is not available, install it temporarily
nix-shell -p git

# Clone the repository
git clone https://github.com/benedikt-weyer/nixos-base-stable.git
cd nixos-base-stable
```

If you already have git installed:

```bash
git clone https://github.com/benedikt-weyer/nixos-base-stable.git
cd nixos-base-stable
```

### 2. Generate Hardware Configuration

Run the setup script to automatically generate and configure the hardware-configuration.nix file:

```bash
./setup.sh
```

This script will:
- Generate hardware configuration for your current system
- Place it in the correct location (`hosts/default/hardware-configuration.nix`)
- Create a backup of any existing hardware configuration
- Provide next steps for testing and applying the configuration

### 3. Test and Apply Configuration

After running the setup script, you'll need to test your configuration. This configuration uses Nix flakes, so you have two options:

#### Option A: Use Flakes Temporarily (Recommended)

Use the `--extra-experimental-features` flag without modifying your global configuration:

```bash
# Test configuration with temporary flakes
sudo nixos-rebuild test --extra-experimental-features "flakes nix-command" --flake .

# If everything works, switch to the new configuration
sudo nixos-rebuild switch --extra-experimental-features "flakes nix-command" --flake .
```

#### Option B: Enable Flakes Globally

If you have flakes enabled globally in your system configuration:

```bash
# Test configuration
sudo nixos-rebuild test --flake .

# If everything works, switch to the new configuration
sudo nixos-rebuild switch --flake .
```

To enable flakes globally, add this to your `/etc/nixos/configuration.nix`:

```nix
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
```

Then run `sudo nixos-rebuild switch` before using this configuration.

## Prerequisites

This configuration is designed for NixOS systems and uses Nix flakes. No additional setup is required - the flakes can be used temporarily as shown in step 3 above.

## Configuration Structure

```
├── flake.nix                    # Main flake configuration
├── hosts/
│   └── default/
│       ├── configuration.nix    # System configuration
│       ├── home.nix             # Home Manager configuration
│       └── hardware-configuration.nix  # Generated hardware config
└── modules/
    ├── git.nix                  # Git configuration
    ├── nixvim.nix              # Neovim configuration
    └── zsh.nix                 # Zsh shell configuration
```

## Features

- **Multiple nixpkgs channels**: Stable (25.05), unstable, and 24.11
- **Home Manager integration**: User-level package and service management
- **Nixvim**: Neovim configuration with Nix
- **Custom packages**: Support for custom package definitions
- **Modular structure**: Easy to extend and customize

## Customization

- Edit `hosts/default/configuration.nix` for system-level changes
- Edit `hosts/default/home.nix` for user-level changes
- Add new modules in the `modules/` directory
- Configure custom packages in `modules/custom-packages/`

## Troubleshooting

### "experimental Nix feature 'flakes' is disabled" error

You have two options to resolve this:

1. **Use temporary flakes** (recommended): Add `--extra-experimental-features "flakes nix-command"` to your nixos-rebuild commands:
   ```bash
   sudo nixos-rebuild test --extra-experimental-features "flakes nix-command" --flake .
   ```

2. **Enable flakes globally**: See the [Prerequisites](#prerequisites) section above.

### "command 'nix' not found" or Nix not available

This error occurs if Nix is not installed. This configuration is specifically designed for NixOS systems.

### "nixos-rebuild: command not found"

This error occurs if you're not running on a NixOS system. This configuration is specifically designed for NixOS.

### Hardware configuration errors

If you encounter hardware-related errors, try regenerating the hardware configuration:

```bash
./setup.sh
```

This will create a fresh hardware configuration based on your current system.

### Git not available

If git is not installed on your system, you can install it temporarily:

```bash
nix-shell -p git
```

Then proceed with cloning the repository.
