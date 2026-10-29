# justfile for mnemosyne NixOS configuration
# https://github.com/casey/just

# Default host and flake path (override with `just --set host <name>`)
host := "hephaestus"
flake := ".#" + host

# Show available recipes
default:
    @just --list

# Build the NixOS configuration without switching
build:
    sudo nixos-rebuild build --flake {{ flake }}

# Rebuild and switch to the new configuration
switch:
    sudo nixos-rebuild switch --flake {{ flake }}

# Rebuild and test the configuration (does not add a bootloader entry)
test:
    sudo nixos-rebuild test --flake {{ flake }}

# Rebuild and set the configuration to be activated on next boot
boot:
    sudo nixos-rebuild boot --flake {{ flake }}

# Show what would change without actually applying
dry:
    sudo nixos-rebuild dry-activate --flake {{ flake }}

# Update all flake inputs
update:
    nix flake update

# Update a specific flake input (e.g. `just update-input nixpkgs`)
update-input input:
    nix flake lock --update-input {{ input }}

# Format the repository using the configured formatter
fmt:
    nix fmt

# Lint / check the flake
check:
    nix flake check

# Show flake metadata
metadata:
    nix flake metadata

# List system generations
generations:
    sudo nix-env -p /nix/var/nix/profiles/system --list-generations

# Diff the current system against the new flake build
diff:
    nix run nixpkgs#nvd -- diff /run/current-system result

# Run garbage collection (keeps everything)
gc:
    sudo nix-collect-garbage

# Run garbage collection and delete generations older than 30 days
gc-old:
    sudo nix-collect-garbage --delete-older-than 30d

# Delete all non-current generations and run garbage collection
gc-all:
    sudo nix-collect-garbage -d

# Roll back to the previous generation
rollback:
    sudo nixos-rebuild switch --rollback
