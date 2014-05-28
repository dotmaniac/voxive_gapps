#!/sbin/sh
# 
# /system/addon.d/74-googlecamera.sh
#
. /tmp/backuptool.functions

list_files() {
cat <<EOF
app/GalleryGoogle.apk
lib/libjni_eglfence.so
lib/libjni_filtershow_filters.so
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
    rm -f /system/app/Gallery.apk
    rm -f /system/priv-app/Gallery.apk
    rm -f /system/app/Gallery2.apk
    rm -f /system/priv-app/Gallery2.apk
  ;;
  post-restore)
    # Stub
  ;;
esac
