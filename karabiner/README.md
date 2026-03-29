# Karabiner setup notes

## Configuration path

This repository symlinks the whole `~/.config/karabiner` directory to this
`karabiner/` directory.

Karabiner's official documentation says that symlinking the directory is the
supported way to relocate the configuration directory.

Reference:

- https://karabiner-elements.pqrs.org/docs/manual/misc/configuration-file-path/

## Important caveat when the real directory is under `~/Desktop`

If the real directory behind `~/.config/karabiner` lives under
`~/Desktop/projects/...`, the GUI may show the configuration correctly while
device remapping does not actually change.

This happens because Karabiner's background processes also need permission to
read files under Desktop-protected paths.

The official docs call out that these two processes need additional access when
the target directory is under `Desktop` or `Downloads`:

- `Karabiner-Core-Service`
- `karabiner_console_user_server`

## Required setup

When setting up a new machine with this repo:

1. Open `System Settings > Privacy & Security > Full Disk Access`.
2. Enable Full Disk Access for:
   - `Karabiner-Core-Service`
   - `karabiner_console_user_server`
3. Restart macOS.

If the config was just moved or relinked, restarting
`karabiner_console_user_server` may also be required.

Example:

```sh
launchctl kickstart -k gui/$(id -u)/org.pqrs.service.agent.karabiner_console_user_server
```

If these entries are not listed, you can press the + button, navigate to the following locations, and add them from there.

`Macintosh HD > Library > Application Support > org.pqrs > Karabiner-Elements`
`Macintosh HD > Library > Application Support > org.pqrs > Karabiner-Elements > bin`

## Safer alternative

To avoid Desktop privacy issues entirely, place the real Karabiner directory in
a non-Desktop location and symlink `~/.config/karabiner` to that location.

Examples mentioned in the official docs:

- `~/Library/Application Support/org.pqrs/config/karabiner`
- `~/.local/share/karabiner`
