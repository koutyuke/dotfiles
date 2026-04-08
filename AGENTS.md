# Agent Instructions

## Project Overview

This repository contains declarative macOS dotfiles for the `koutyuke` host.
It is built around `nix-darwin`, `home-manager`, `flake-parts`, `brew-nix`,
and `treefmt-nix`.

The active flake target is:

```bash
.#darwinConfigurations.koutyuke
```

The supported system is `aarch64-darwin`.

## Repository Layout

- `flake.nix`: flake entry point and input definitions.
- `nix/flakes/`: flake-parts modules for hosts, apps, and treefmt.
- `nix/lib/mk-darwin-system.nix`: shared constructor for darwin systems.
- `nix/modules/darwin/`: shared system-wide macOS and nix-darwin modules.
- `nix/modules/home/`: shared home-manager user modules.
- `nix/hosts/koutyuke/`: host-specific configuration.
- `nix/hosts/koutyuke/users/kousuke/`: user-specific configuration.
- `nix/overlays/`: package and brew-cask overlays.
- `karabiner/`: Karabiner configuration linked into the user config.
- `docs/package-management.md`: detailed package placement rules.

## Change Guidelines

Prefer existing module boundaries and keep changes narrowly scoped.

- Shared macOS or nix-darwin settings belong in `nix/modules/darwin/`.
- Shared user packages and home-manager settings belong in `nix/modules/home/`.
- Host-specific settings for `koutyuke` belong in `nix/hosts/koutyuke/`.
- User-specific settings for `kousuke`, including Git identity and personal or
  work-only packages, belong in `nix/hosts/koutyuke/users/kousuke/`.
- Program configuration should use `programs.<tool>` modules when home-manager
  or nix-darwin already provides one; do not also add the same tool to a package
  list unless the local pattern requires it.

For package placement, follow `docs/package-management.md`:

- Prefer `pkgs.brewCasks` for GUI apps when system integration is not needed.
- Use `homebrew.casks` for apps that need `/Applications`, URI scheme
  registration, browser extension integration, privileged helpers, kernel or
  system extensions, VPN clients, custom taps, or when brew-nix cannot be made to
  build cleanly.
- Use `homebrew.masApps` only when an app is distributed through the Mac App
  Store and not covered by the other mechanisms.
- Use nixpkgs for CLI tools when available; use Homebrew formulae only when
  nixpkgs is not suitable.

## Commands

Format the repository:

```bash
nix fmt
```

Build without switching:

```bash
nix build .#darwinConfigurations.koutyuke.system
```

Apply the configuration on the target machine:

```bash
darwin-rebuild switch --flake .#koutyuke
```

Update flake inputs and run garbage collection:

```bash
nix run .#update
```

## Editing Notes

- Use Nix module style that matches the surrounding files.
- Do not make unrelated formatting or lockfile changes.
- Do not edit `flake.lock` unless the task explicitly involves updating inputs.
- Keep Karabiner changes in `karabiner/karabiner.json`; it is symlinked by the
  darwin dotfiles module rather than copied into the Nix store.
- Before committing, run `nix fmt` for Nix changes and prefer a build check when
  the change affects module wiring, packages, overlays, or flake inputs.
