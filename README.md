# omarchy-config

My [Omarchy](https://omarchy.org) setup: the files I actually changed, and why.

Omarchy is an opinionated Arch + Hyprland desktop, and most of it needs no
touching. What is here is the delta — nothing that matches a stock default is
tracked, so every file in this repo exists for a reason spelled out below.

```bash
git clone https://github.com/viktorvillalobos/omarchy-config.git
cd omarchy-config && ./install
```

`install` copies into `~/.config`, backing up whatever it replaces. `pull` does
the reverse, which is how you find out what an update changed — see
[Surviving updates](#surviving-updates).

## Hyprland

### `hypr/input.lua` — Mac key order on a PC keyboard

A Logitech K950 sends Super where a Mac sends Alt and vice versa, so
`altwin:swap_lalt_lwin` swaps the **left** pair and restores the Mac order:

```
ctrl | fn | alt (opt) | super (cmd) | space
```

Deliberately not `altwin:swap_alt_win`, which swaps the right pair too and
would break AltGr — and AltGr is not optional on the `es` layout, where it is
the only way to type `@ # ~ \ | [ ] { }`.

This one file is why the rest of the bindings feel right. Lose it and every
shortcut still fires, just under the wrong thumb.

### `hypr/bindings.lua` — the Mac shortcut layer

Cmd+C/V/Q/W/T and friends, forwarded to their Ctrl equivalents, with terminals
excluded so `Ctrl+C` keeps meaning SIGINT. Plus the K950's dedicated keys,
which send Windows chords rather than their own keycodes: capture sends
`ALT+SHIFT+S`, lock sends `ALT+L`.

Also `SUPER + ALT + R` for the workspace name/icon panel — that widget is
zero-width until a workspace has a label, so without a key there is nothing to
click the first time.

### `hypr/monitors.lua` — Samsung S34CG50

3440x1440 across 34.2" is ~109 PPI, and Omarchy is tuned for 218+ PPI panels,
so the retina defaults do not apply. Also pins `3440x1440@100`: `preferred`
picked 59.97 Hz on a panel that does 100.

## Omarchy shell

### `omarchy/shell.json` — the bar

- **CPU, RAM and network** as `type: "command"` modules, fed by the scripts
  below.
- **Tray icons pinned.** By default they hide behind a chevron and only appear
  on hover; on a 34" screen there is no reason to hide anything.
- **`alwaysShow` on indicators**, for the same reason.
- Uses the two cloned plugins below instead of their built-in originals.

### `omarchy/bar/scripts/` — the metrics

Three small scripts, all avoiding the obvious naive implementation:

| Script | What it does |
|---|---|
| `cpu-usage` | Delta of `/proc/stat` between invocations, with the previous counter cached — so no blocking `sleep` inside the script |
| `mem-usage` | `MemTotal - MemAvailable`, i.e. actually-used memory, not counting reclaimable cache |
| `net-usage` | Throughput of the default-route interface, found by reading `/proc/net/route` directly rather than shelling out to `ip` |

`net-usage` divides by elapsed time from `/proc/uptime` rather than by the
module's nominal interval, so a late tick still reports the right rate. All
three pad their output to a fixed width — without that, going from `0B` to
`12.7M` resizes the module every sample and shoves its neighbours sideways.

### `omarchy/shell.toml`

Shell font base size at 11. One line, but it changes every panel's type scale.

## Shell plugins

Both are clones of built-in Omarchy plugins with local patches. `omarchy plugin
clone` names a clone after the user running it, which is why `install` renames
them and why `shell.json` refers to `<user>.workspaces`.

Being clones, they do **not** track upstream: improvements to
`omarchy.workspaces` or `omarchy.background` will not reach them.

### `plugins/workspaces/` — icons and labels per workspace

The stock widget shows numbers. This one gives each workspace an icon and an
optional label, with a settings panel (right-click any workspace) holding a
48-icon picker. Icons are stored as codepoints rather than literal glyphs —
Private Use Area characters do not survive every text pipeline, and a map of
them reads as a column of blanks in a diff.

Two other changes: workspaces 1–9 are always shown rather than only the
occupied ones, and the focused workspace keeps its icon and takes the accent
color instead of being replaced by a filled square, which used to hide the icon
on the one workspace you were looking at.

### `plugins/background/` — live shader wallpapers

Patches the background renderer so a wallpaper named `*-live.<ext>` is replaced
by `tools/<name>.frag.qsb` from the current theme, rendered live. The still
image stays as the fallback, so without the shader nothing breaks.

Cheap by construction: a Wayland layer surface stops getting frame callbacks
once a window covers it, so an occluded wallpaper costs 0% CPU, and
`UPower.onBattery` hides the shader entirely on a laptop.

The shaders themselves live in the theme, not here — see
[zavudev/omarchy-theme](https://github.com/zavudev/omarchy-theme).

## Misc

`spotify-flags.conf` — the Wayland flags Spotify needs to stop being rendered
through XWayland, which on a fractional-scaled display means blurry.

## Not in here

Cloned separately, not vendored:

| What | Where |
|---|---|
| Zavu theme | [zavudev/omarchy-theme](https://github.com/zavudev/omarchy-theme) |
| Workspace name plugin | [jankeesvw/omarchy-workspace-name](https://github.com/jankeesvw/omarchy-workspace-name) |
| Akaito, Last Horizon themes | installed with `omarchy theme install` |

## Surviving updates

`omarchy update` runs migrations that **overwrite these files with stock
defaults**. It backs each one up as `<file>.bak.<timestamp>` first, so nothing
is lost — but you find out when a shortcut stops working, not when it happens.

This repo is the early warning:

```bash
./pull && git diff
```

Anything that shows up is what the update took away. `./install` puts it back.

## License

MIT
