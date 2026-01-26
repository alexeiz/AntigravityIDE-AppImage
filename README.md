<h2 align="center">Antigravity AppImage</h2>
<p align="center">Unofficial / Community provided Google Antigravity AppImage</p>

[![Antigravity AppImage release](https://github.com/tyvsmith/Antigravity-AppImage/actions/workflows/release.yml/badge.svg?branch=main)](https://github.com/tyvsmith/Antigravity-AppImage/actions/workflows/release.yml)

## Get Started

#### [Download the latest release](https://github.com/tyvsmith/Antigravity-AppImage/releases/latest)
- Automatically built from the latest stable release
- Supports AppImage self-update

### Executing
#### File Manager
Double-click the `*.AppImage` file and you are done!

> In normal cases, the above method should work, but in some cases you
> need to mark the file as executable. You can do this using File manager -> right click > Properties > Allow Execution,
> or by terminal issuing command `chmod +x Antigravity-*.AppImage`

#### AppImageLauncher
Use AppImageLauncher for better desktop integration: [download AppImageLauncher](https://github.com/TheAssassin/AppImageLauncher)

#### Terminal
```bash
chmod +x Antigravity-*.AppImage
./Antigravity-*.AppImage
```

#### Official Downloads
The official Google Antigravity downloads are available at:
https://antigravity.google/download

#### Build
The AppImage is built from the official `.tar.gz` Linux package by GitHub Actions using:
https://github.com/tyvsmith/appimage-bash
