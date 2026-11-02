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

Note: PLM maintains an allowlist for wallpaper plugins displayed in its Appearance dropdown. Third-party plugins may not appear there. This does not prevent the greeter from loading a plugin selected manually through WallpaperPluginId.

After setting the plugin ID, open System Settings → Security & Privacy → Login Screen → Appearance. The plugin's configuration page provides controls for assigning images to individual displays and setting a fallback image.

## Configuration

Each mapping pairs a Qt screen name with an image URL. The plugin supports formats recognized by Qt.

For example:
```json
[
  {
    "screen": "DP-2",
    "image": "file:///usr/share/backgrounds/plm-multiscreen/landscape.jpg"
  },
  {
    "screen": "DP-3",
    "image": "file:///usr/share/backgrounds/plm-multiscreen/portrait.jpg"
  }
]
```

The fallback image is used whenever the current screen has no matching mapping or its mapped image is empty. The display names must match the names reported to the greeter, not necessarily those shown in the desktop session.

## Image permissions

The greeter runs separately from your desktop session. The PLM service account must be able to read every image file and traverse every parent directory.

A recommended location for shared wallpapers is:

`/usr/share/backgrounds/`

For example:

`/usr/share/backgrounds/plm-multiscreen/`

Files should be readable by the PLM service account. Avoid placing wallpapers in private home directories unless you have explicitly configured the necessary permissions.

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
