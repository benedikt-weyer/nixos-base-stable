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

After the hardware configuration is generated, add it to git tracking (required for flakes):

```bash
git add .
```

### 3. Apply Configuration

After running the setup script, apply the configuration:

```bash
sudo nixos-rebuild switch --flake .#default
```

## Prerequisites

This configuration is designed for NixOS systems and uses Nix flakes. You need to enable flakes in your system configuration.

Add the following to your `/etc/nixos/configuration.nix`:

```nix
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
```

Then rebuild your system:

```bash
sudo nixos-rebuild switch
```

After enabling flakes, you can use this configuration.

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

You need to enable flakes globally in your system configuration. See the [Prerequisites](#prerequisites) section above for instructions.

### "error: getting status of '/nix/store/...-source/flake.nix': No such file or directory"

Make sure you're running the command from within the cloned repository directory:

```bash
cd nixos-base-stable
sudo nixos-rebuild switch --flake .#default
```

### "error: path '/nix/store/...' does not exist and cannot be created"

This usually means the generated hardware configuration isn't tracked by git. Make sure to add files to git after running the setup script:

```bash
git add .
sudo nixos-rebuild switch --flake .#default
```

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
