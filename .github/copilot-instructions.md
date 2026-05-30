# Copilot Instructions for Antigravity-AppImage

## Build and validation

- The repo does not have a local app build, test, or lint harness. The shipped AppImage is produced by `.github/workflows/release.yml`.
- Use `bash ./scripts/get-download-url.sh` to validate the upstream URL discovery logic before changing the release workflow.

## High-level architecture

- This repository is release automation plus Linux desktop metadata, not the Antigravity application source itself. The actual app payload comes from the official Antigravity Linux `.tar.gz` download referenced in `README.md`.
- `scripts/get-download-url.sh` discovers the current upstream Linux package in two steps: it fetches `https://antigravity.google/download/linux`, extracts the cache-busted `main-*.js` bundle name, then scans that bundle for the `Antigravity.tar.gz` URL.
- `.github/workflows/release.yml` is the packaging entrypoint. It runs on pushes to `main`, on a 12-hour schedule, and on manual dispatch. The workflow:
  - installs `libfuse2` and `imagemagick`,
  - runs `./scripts/get-download-url.sh`,
  - hands the resolved URL to `tyvsmith/appimage-bash@main`,
  - reads the upstream app version from `resources/app/product.json` with `jq -r ".ideVersion"`,
  - uploads and publishes `dist/` only when the action reports `APP_UPDATE_NEEDED == 'true'`.
- `app.desktop` and `app-url-handler.desktop` provide the Linux integration that gets bundled into the AppImage: the main launcher runs `antigravity`, the desktop action adds `--new-window`, and the URL handler maps `antigravity://` links to `antigravity --open-url`.

## Key conventions

- Treat the workflow plus `scripts/get-download-url.sh` as the source of truth for packaging. If release behavior changes, update those pieces instead of inventing a separate local build path.
- Keep the URL scraping script strict and fail-fast (`set -euo pipefail`). An empty match should stop the workflow rather than silently publishing a broken build.
- Preserve the release gating from `APP_UPDATE_NEEDED`; the workflow is designed to publish only when the upstream Antigravity version changes.
- Keep desktop entry metadata aligned with the packaged binary name `antigravity`, including the `new-empty-window` action, workspace MIME association, and `x-scheme-handler/antigravity` handler.
- README promises automated builds from the latest stable release and AppImage self-update support, so be cautious about changes to artifact naming, release tagging, and other update-related workflow behavior.
