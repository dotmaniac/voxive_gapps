#!/sbin/sh
# 
# /system/addon.d/78-chromebrowser.sh
#
. /tmp/backuptool.functions

list_files() {
cat <<EOF
app/Chrome.apk
lib/libchrome.1916.122.so
EOF
}

case "$1" in
  backup)
    list_files | while read FILE DUMMY; do
      backup_file $S/$FILE
    done
  ;;
  restore)
    list_files | while read FILE REPLACEMENT; do
      R=""
      [ -n "$REPLACEMENT" ] && R="$S/$REPLACEMENT"
      [ -f "$C/$S/$FILE" ] && restore_file $S/$FILE $R
    done
  ;;
  pre-backup)
    # Stub
  ;;
  post-backup)
    # Stub
  ;;
  pre-restore)
    # Check for existence of .gapps-stock in /sdcard for flash modifications
    if [ -e /sdcard/.gapps-stock ]; then
        if ! (grep -qi "browser" /sdcard/.gapps-stock ); then
            # Remove the stock/AOSP Browser
            rm -f /system/app/Browser.apk
        fi
    else
        # Remove the stock/AOSP Browser
        rm -f /system/app/Browser.apk
    fi
  ;;
  post-restore)
    # Stub
;;
esac
