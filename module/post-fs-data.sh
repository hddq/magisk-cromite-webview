#!/system/bin/sh
# Cromite SystemWebView — post-fs-data.sh
# Runs at post-fs-data mode (before Zygote starts).
# Sets SELinux context early so the WebView APK is ready before apps launch.

MODDIR="${0%/*}"
APK_PATH="$MODDIR/system/app/webview/webview.apk"

if [ -f "$APK_PATH" ]; then
    chcon u:object_r:apk_data_file:s0 "$APK_PATH" 2>/dev/null || true
fi
