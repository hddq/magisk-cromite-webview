# Cromite SystemWebView — Magisk Module

![Build Status](https://github.com/hddq/magisk-cromite-webview/actions/workflows/build.yml/badge.svg)
![Latest Release](https://img.shields.io/github/v/release/hddq/magisk-cromite-webview)
![Downloads](https://img.shields.io/github/downloads/hddq/magisk-cromite-webview/total)

A Magisk module that replaces the stock Android System WebView with [Cromite WebView](https://github.com/uazo/cromite).

## Requirements
- arm64-v8a architecture
- Magisk v20.4+

## Features

- **Drop-in WebView replacement** — overlays the stock WebView at `/system/app/webview/`
- **Automatic updates** — Magisk Manager detects new versions via `updateJson`
- **Zero-touch CI/CD** — GitHub Actions checks for new Cromite releases every 24 hours

## Installation

### From GitHub Releases (recommended)

1. Download the latest `CromiteSystemWebView-*.zip` from [Releases](../../releases)
2. Open **Magisk Manager** → Modules → Install from storage
3. Select the downloaded zip
4. Reboot

### Auto-updates

Once installed, Magisk Manager will automatically detect new versions in the **Modules** tab. Just tap "Update" when prompted.

## Module Structure

```
module/
├── META-INF/
│   └── com/google/android/
│       ├── update-binary        # Magisk installer bootstrap
│       └── updater-script       # Required placeholder
├── system/
│   └── app/
│       └── webview/
│           └── webview.apk      # Cromite SystemWebView (placed by CI)
├── module.prop                  # Module metadata + updateJson
├── customize.sh                 # Install-time script
├── service.sh                   # Late-start service (permission fix)
└── post-fs-data.sh              # Early boot (SELinux context)
```

## CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/build.yml`):

1. Runs on a 24-hour schedule (04:00 UTC daily) + manual dispatch
2. Queries the [Cromite releases API](https://api.github.com/repos/uazo/cromite/releases/latest) for the latest tag
3. Checks if a GitHub Release with that tag already exists
4. If a new version exists:
   - Downloads `arm64_SystemWebView.apk`
   - Patches `module.prop` with the new version/versionCode
   - Packages the Magisk module zip
   - Updates `update.json` for Magisk Manager auto-updates
   - Publishes a GitHub Release with the zip attached
5. If already up-to-date, exits cleanly
