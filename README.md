# PLM Multi-Screen Wallpaper

A Plasma Login Manager (PLM) wallpaper plugin that lets each display use its own image.

Unlike a fixed dual-monitor setup, this plugin maps **display names** to image files. It can therefore be used with any number of displays, provided PLM/Qt exposes their screen names.

## Features

- Independent wallpaper image for each configured display.
- A fallback image for displays without an explicit mapping.
- Add and remove display mappings in the configuration page.
- Uses Qt Quick's screen information at runtime; no fixed DP-2/DP-3 assumptions.
- Lightweight QML package; no daemon or background service.

## Requirements

- Plasma Login Manager (PLM) with the Plasma/Wallpaper package support.
- KDE Plasma / Qt 6 runtime.
- Arch Linux or an Arch-based distribution for the supplied PKGBUILD.

The plugin is not the KDE Plasma desktop wallpaper plugin. It is specifically for the **Plasma Login Manager greeter**.

## Install (Arch Linux)

The package is intended for the Arch User Repository (AUR). Until an AUR package is published, you can build it from a local checkout:

```bash
git clone https://github.com/gqpdx/plm-multiscreen-wallpaper.git
cd plm-multiscreen-wallpaper
makepkg -si
```

The package installs the wallpaper plugin under:

```
/usr/share/plasma/wallpapers/io.github.gqpdx.plm-multiscreen-wallpaper/
```

## Enable the plugin

Set the plugin ID in `/etc/plasmalogin.conf`:

```ini
[Greeter]
WallpaperPluginId=io.github.gqpdx.plm-multiscreen-wallpaper
```

Preserve any other settings already present in that file. Back it up before editing.

Then open the PLM wallpaper configuration page (if exposed by your installed PLM/KDE configuration tools), configure the display mappings and fallback image, and restart the greeter or reboot to test.

If your PLM build does not expose third-party wallpaper configuration pages, the plugin can still be configured through its KConfig group. The configuration UI and its integration vary by PLM/KDE build; see [Configuration](#configuration).

## Configuration

Each mapping pairs a Qt screen name with an image URL. For example:

```json
[
  {
    "screen": "DP-2",
    "image": "file:///var/lib/plasmalogin/wallpapers/landscape.jpg"
  },
  {
    "screen": "DP-3",
    "image": "file:///var/lib/plasmalogin/wallpapers/portrait.jpg"
  }
]
```

The fallback image is used whenever the current screen has no matching mapping or its mapped image is empty.

**Important: image permissions**

The greeter runs separately from your desktop session. The PLM service account must be able to read every image file and traverse every parent directory. A file inside a private home directory (for example, `/home/your-user/Pictures` when the home directory is mode `0700`) will generally not be readable by the greeter.

A practical location is a directory such as `/var/lib/plasmalogin/wallpapers/` with image files readable by the PLM service account. Do not make your entire home directory world-readable just to expose a wallpaper.

## Finding display names

Run this from your desktop session:

```bash
kscreen-doctor -o
```

Use the connector/output name shown by your system (for example, `DP-2`) as the mapping's `screen` value. Qt's screen name as seen by the greeter is the value used for matching; names can differ between hardware, drivers, and sessions.

## Troubleshooting

- **Fallback appears on every display:** verify the configured screen names match the names PLM/Qt reports, including capitalization.
- **An image is missing:** check that the PLM service account can read the file and traverse its parent directories.
- **Orientation is wrong:** monitor orientation is controlled by PLM/KWin output configuration, not by this wallpaper plugin.
- **Changes do not appear:** restart the greeter or reboot after changing the plugin selection/configuration.

## Development

The plugin is a standard KPackage wallpaper package:

```
metadata.json
contents/
  config/
    main.xml
  ui/
    main.qml
    config.qml
```

Validate the QML with `qmllint` and the metadata/config XML with standard JSON/XML validators before packaging.

## License

GPL-2.0-or-later. See [LICENSE](LICENSE).
