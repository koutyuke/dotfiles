# dotfiles

Declarative macOS system configuration using [Nix Flakes](https://nixos.wiki/wiki/Flakes), [nix-darwin](https://github.com/nix-darwin/nix-darwin), and [home-manager](https://github.com/nix-community/home-manager).

## Overview

This repository manages the entire macOS environment — system settings, packages, GUI applications, shell configuration, and dotfiles — all through Nix.

**Key technologies:**

- **nix-darwin** — Declarative macOS system configuration
- **home-manager** — Per-user package and dotfile management
- **flake-parts** — Modular flake structure
- **brew-nix** — Homebrew Casks as Nix derivations (no Homebrew installation required)
- **treefmt-nix** — Unified code formatting

## Repository Structure

```text
.
├── flake.nix                          # Flake entrypoint & input definitions
├── flake.lock
│
├── flakes/                            # Flake output modules
│   ├── hosts.nix                      # darwinConfigurations (host definitions)
│   └── ...
│
├── lib/                               # Helper functions
├── overlays/                          # Nixpkgs overlays
│
├── hosts/                             # Per-host configurations
│   └── <hostname>/
│       ├── configuration.nix          # nix-darwin config (host-specific)
│       └── users/
│           └── <username>/
│               └── home.nix           # home-manager config (user-specific)
│
└── modules/                           # Shared, reusable modules
    ├── darwin/                        # System-level (nix-darwin) modules
    │   ├── default.nix                # Module imports
    │   ├── base.nix                   # System packages, fonts, Nix settings
    │   └── defaults.nix               # macOS system preferences
    │
    └── home/                          # User-level (home-manager) modules
        ├── default.nix                # Module imports
        ├── packages.nix               # Nix packages (CLI & dev tools)
        ├── casks.nix                  # Homebrew Casks (GUI applications)
        └── programs/                  # Programs with configuration
```

## Architecture

### Configuration Flow

```text
flake.nix
 └─ flakes/hosts.nix                    # Defines hosts, applies overlays
      └─ lib/mk-darwin-system.nix        # Wires nix-darwin + home-manager + brew-nix
           └─ hosts/<host>/configuration.nix
                ├─ modules/darwin/        # System-wide settings
                └─ users/<user>/home.nix
                     └─ modules/home/     # User-wide settings
```

### Layer Responsibilities

| Layer               | Location                             | Purpose                                             |
| ------------------- | ------------------------------------ | --------------------------------------------------- |
| **Overlays**        | `overlays/`                          | Patch package derivations (cask hashes, variations) |
| **System (shared)** | `modules/darwin/`                    | macOS defaults, system packages, fonts, security    |
| **User (shared)**   | `modules/home/packages.nix`          | CLI tools & dev tools shared across all users       |
| **User (shared)**   | `modules/home/casks.nix`             | GUI applications shared across all users            |
| **User (shared)**   | `modules/home/programs/`             | Program-specific settings & dotfiles                |
| **Host-specific**   | `hosts/<host>/configuration.nix`     | Hostname, user bindings                             |
| **User-specific**   | `hosts/<host>/users/<user>/home.nix` | User-specific packages, git identity, etc.          |

## Usage

### Prerequisites

- macOS (aarch64)
- [Nix](https://nixos.org/download) (installed via [DeterminateSystems/nix-installer](https://github.com/DeterminateSystems/nix-installer))

### Build & Apply

```bash
# Build and switch to the new configuration
darwin-rebuild switch --flake .

# Build without switching (dry run)
darwin-rebuild build --flake .
```

### Format Code

```bash
nix fmt
```

### Update Commands

```bash
# Update flake inputs only
nix run .#update

# Apply Nix/Homebrew/MAS updates from the current lock file
nix run .#upgrade
```
