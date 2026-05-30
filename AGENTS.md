# Repository Guidelines

## Project Structure & Module Organization

This repository packages the official Google Antigravity IDE Linux archive as an AppImage. It does not contain the Antigravity application source.

- `README.md` documents user-facing installation and release behavior.
- `.github/workflows/release.yml` is the main build and release entrypoint.
- `scripts/get-download-url.sh` discovers the latest upstream Linux x64 `.tar.gz` download URL.
- `app.desktop` and `app-url-handler.desktop` define Linux launcher and URL-handler metadata bundled into the AppImage.
- `LICENSE` contains the repository license.

There are no source modules, test directories, or checked-in binary assets in the current layout.

## Build, Test, and Development Commands

- `bash ./scripts/get-download-url.sh`: validates that the scraper can find the current upstream Antigravity Linux archive URL.
- `shellcheck scripts/get-download-url.sh`: recommended before changing shell logic, if ShellCheck is installed.
- GitHub Actions workflow `Build AppImage`: builds, uploads, and releases the AppImage on `main`, manual dispatch, and the scheduled 12-hour check.

Local AppImage builds are not defined here; packaging is delegated to `tyvsmith/appimage-bash@main` in the release workflow.

## Coding Style & Naming Conventions

Shell scripts should use Bash with `set -euo pipefail`, quote variables, and fail loudly when expected upstream values are missing. Keep scraping logic simple and auditable.

YAML workflow files use two-space indentation. Preserve existing action names, environment variables, and release gating around `APP_UPDATE_NEEDED` unless intentionally changing release behavior.

Desktop entry files should keep executable, icon, MIME type, and scheme-handler names aligned with the packaged Antigravity binary and desktop integration.

## Testing Guidelines

There is no automated test suite. Validate changes by running `bash ./scripts/get-download-url.sh` and confirming it prints a single download URL. For workflow changes, inspect `.github/workflows/release.yml` carefully and prefer a manual `workflow_dispatch` run after merging.

## Commit & Pull Request Guidelines

Recent commits use short, imperative, lowercase summaries, for example `rename release workflow` and `fix file paths in workflow definition`. Follow that style and keep commits narrowly scoped.

Pull requests should include a concise description, the reason for the change, validation performed, and any expected release impact. Include screenshots only for visible desktop metadata changes.

## Security & Configuration Tips

Do not commit downloaded AppImages, upstream archives, secrets, or generated `dist/` artifacts. Treat `GITHUB_TOKEN` usage and automatic release permissions as workflow-sensitive changes. Changes to upstream URL matching should prefer strict failures over silently publishing stale or broken packages.
