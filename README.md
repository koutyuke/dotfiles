# dotfiles

Declarative macOS dotfiles built with `nix-darwin` and `home-manager`.
This repository manages system settings, CLI tools, GUI applications, shell configuration, and Karabiner settings through a single Nix Flake.

## Stack

- `nix-darwin`: macOS system configuration
- `home-manager`: user environment and dotfile management
- `flake-parts`: modular flake outputs
- `brew-nix`: Homebrew Casks exposed as Nix packages
- `treefmt-nix`: unified `nix fmt` configuration

## Current Layout

The current flake defines a single `koutyuke` host for `aarch64-darwin`.

```text
.
├── flake.nix
├── flake.lock
├── README.md
├── docs/
│   └── package-management.md
├── karabiner/
│   └── karabiner.json
└── nix/
    ├── flakes/
    │   ├── apps.nix
    │   ├── default.nix
    │   ├── hosts.nix
    │   └── treefmt.nix
    ├── hosts/
    │   └── koutyuke/
    │       ├── configuration.nix
    │       └── users/
    │           └── kousuke/
    │               └── home.nix
    ├── lib/
    │   └── mk-darwin-system.nix
    ├── modules/
    │   ├── darwin/
    │   │   ├── configuration.nix
    │   │   ├── default.nix
    │   │   ├── dotfiles/
    │   │   ├── homebrew.nix
    │   │   ├── packages.nix
    │   │   └── programs.nix
    │   └── home/
    │       ├── default.nix
    │       ├── packages.nix
    │       └── programs/
    └── overlays/
        ├── brew-casks.nix
        └── packages.nix
```

## Configuration Flow

```text
flake.nix
└── nix/flakes/default.nix
    ├── nix/flakes/hosts.nix
    │   └── nix/lib/mk-darwin-system.nix
    │       └── nix/hosts/koutyuke/configuration.nix
    │           ├── nix/modules/darwin/
    │           └── nix/hosts/koutyuke/users/kousuke/home.nix
    │               └── nix/modules/home/
    ├── nix/flakes/apps.nix
    └── nix/flakes/treefmt.nix
```

Responsibilities are split as follows:

- `nix/modules/darwin/`: shared system-wide settings
- `nix/modules/home/`: shared user-level settings
- `nix/hosts/koutyuke/`: host-specific settings
- `nix/hosts/koutyuke/users/kousuke/`: user-specific settings
- `nix/overlays/`: package overrides for `brew-nix` and custom packages

## What This Repository Manages

- Core macOS settings
  - timezone
  - Touch ID for `sudo`
  - fonts
- System-level application integration
  - `homebrew.casks`
  - `masApps`
  - applications that must live in `/Applications`
- User-level CLI and GUI tools
  - `home.packages`
  - `programs.<tool>`
- Karabiner configuration
  - [`karabiner/karabiner.json`](./karabiner/karabiner.json)
  - linked into `~/.config/karabiner` by an activation script

## Key Files

- [`flake.nix`](./flake.nix)
  - flake entry point and input definitions
- [`nix/flakes/hosts.nix`](./nix/flakes/hosts.nix)
  - defines `darwinConfigurations.koutyuke`
- [`nix/lib/mk-darwin-system.nix`](./nix/lib/mk-darwin-system.nix)
  - wires together `nix-darwin`, `home-manager`, and `brew-nix`
- [`nix/modules/darwin/configuration.nix`](./nix/modules/darwin/configuration.nix)
  - shared macOS and Nix base settings
- [`nix/modules/darwin/homebrew.nix`](./nix/modules/darwin/homebrew.nix)
  - Homebrew Casks and Mac App Store apps
- [`nix/modules/home/packages.nix`](./nix/modules/home/packages.nix)
  - shared CLI and GUI packages
- [`nix/modules/home/programs/default.nix`](./nix/modules/home/programs/default.nix)
  - imports program-specific configuration for `bat`, `direnv`, `fzf`, `gh`, `git`, `ghostty`, `starship`, and `zsh`
- [`nix/hosts/koutyuke/configuration.nix`](./nix/hosts/koutyuke/configuration.nix)
  - host-specific system settings and additional applications
- [`nix/hosts/koutyuke/users/kousuke/home.nix`](./nix/hosts/koutyuke/users/kousuke/home.nix)
  - user-specific packages and Git identity

## Setup And Apply

Prerequisites:

- macOS on Apple Silicon
- Nix is already installed
- `darwin-rebuild` is available
- Homebrew is installed via the official installer (this repository no longer manages the Homebrew installation itself; only `homebrew.casks` and `homebrew.masApps` are managed declaratively by `nix-darwin`)

Install Homebrew once per machine before the first `darwin-rebuild`:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Apply the configuration:

```bash
darwin-rebuild switch --flake .#koutyuke
```

Build without switching:

```bash
darwin-rebuild build --flake .#koutyuke
```

> [!IMPORTANT]
> This repository uses Determinate Nix, so Nix daemon settings are managed
> through `determinateNix.customSettings` instead of `nix.settings`. During
> first-time bootstrap, these settings have not been applied yet. Write the
> `llm-agents` binary cache settings to `/etc/nix/nix.custom.conf` first, then
> switch:
>
> ```bash
> sudo install -m 0644 docs/nix.custom.conf.bootstrap.tmpl /etc/nix/nix.custom.conf
> sudo launchctl kickstart -k system/systems.determinate.nix-daemon
> sudo darwin-rebuild switch --flake .#koutyuke
> ```
>
> After the first successful switch, `/etc/nix/nix.custom.conf` is managed by
> `nix-darwin`. If a manually created `/etc/nix/nix.custom.conf` blocks
> activation as an unmanaged file, check that it contains no critical local-only
> settings, rename it, and run the switch again:
>
> ```bash
> sudo mv /etc/nix/nix.custom.conf /etc/nix/nix.custom.conf.before-nix-darwin
> sudo darwin-rebuild switch --flake .#koutyuke
> ```

Format the repository:

```bash
nix fmt
```

Update flake inputs, apply the system, and run garbage collection:

```bash
nix run .#update
```

The first positional argument overrides the target host (defaults to `koutyuke`):

```bash
nix run .#update -- <host>
```

Update GUI applications (`brew-api` input, Homebrew casks, Mac App Store apps) together with the system:

```bash
nix run .#update-gui
nix run .#update-gui -- <host>
```

Both apps cache `sudo` credentials up front, then run `darwin-rebuild switch` and the system-level `nix-collect-garbage -d` via `sudo`. `nix flake update` and `brew` commands intentionally run without `sudo`.

## Change Guidelines

Use these placement rules by default:

- shared system settings: `nix/modules/darwin/`
- shared user settings: `nix/modules/home/`
- host-specific settings for `koutyuke`: `nix/hosts/koutyuke/`
- user-specific settings for `kousuke`: `nix/hosts/koutyuke/users/kousuke/`

For detailed package placement rules, see [`docs/package-management.md`](./docs/package-management.md).

## Notes

- `brew-nix` is enabled, so GUI applications are split between `pkgs.brewCasks` and `homebrew.casks`
- Homebrew itself is intentionally installed via the official installer instead of `nix-homebrew`. The `nix-darwin` `homebrew.*` options drive the `brew` binary that already exists on the system, and `brew update` / `brew upgrade --cask` work without the read-only-prefix constraints that `nix-homebrew` imposes
- Karabiner config is not copied into the Nix store; the repository's `karabiner/` directory is symlinked instead
- `system.configurationRevision` is populated from the flake `rev` or `dirtyRev`
