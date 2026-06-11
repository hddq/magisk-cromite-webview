#!/system/bin/sh
# Cromite SystemWebView — service.sh
# Runs at late_start service mode (after boot completed).
# Ensures correct permissions and SELinux context survive across reboots.

MODDIR="${0%/*}"
APK_PATH="$MODDIR/system/app/webview/webview.apk"

if [ -f "$APK_PATH" ]; then
    # Ensure correct ownership and permissions
    chown 0:0 "$APK_PATH" 2>/dev/null
    chmod 0644 "$APK_PATH" 2>/dev/null

    # Restore SELinux context
    chcon u:object_r:apk_data_file:s0 "$APK_PATH" 2>/dev/null || true
fi
