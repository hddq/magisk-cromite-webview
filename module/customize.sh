#!/system/bin/sh
# Cromite SystemWebView — Magisk Module Install Script
# This script runs during module installation via Magisk Manager.

SKIPUNZIP=1

# Print module banner
ui_print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ui_print "  Cromite SystemWebView"
ui_print "  Replacing stock WebView with Cromite"
ui_print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Extract module files
ui_print "- Extracting module files..."
unzip -o "$ZIPFILE" -x 'META-INF/*' -d "$MODPATH" >&2

# Verify the APK exists in the zip
if [ ! -f "$MODPATH/system/app/webview/webview.apk" ]; then
    abort "! ERROR: webview.apk not found in module zip. Aborting installation."
fi

# Set permissions
ui_print "- Setting permissions..."
set_perm_recursive "$MODPATH" 0 0 0755 0644
set_perm_recursive "$MODPATH/system/app/webview" 0 0 0755 0644
set_perm "$MODPATH/system/app/webview/webview.apk" 0 0 0644

# Set correct SELinux context on the APK
if [ -x "$(command -v chcon)" ]; then
    ui_print "- Setting SELinux context..."
    chcon u:object_r:apk_data_file:s0 "$MODPATH/system/app/webview/webview.apk" 2>/dev/null || true
fi

ui_print "- Done! Reboot to apply."
ui_print ""
