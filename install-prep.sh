#!/sbin/sh
# Voxive GApps Install Preparation Script

# Current Chrome Browser installed size (in Kbytes)
chrome_size_kb=43556

# Current FaceUnlock installed size (in Kbytes)
faceunlock_size_kb=16668

# Current Google Camera installed size (in Kbytes)
camera_size_kb=20740

# Current Hammerhead Google Gallery installed size (in Kbytes)
gallery_size_kb=11224

# Buffer of extra system space to require for GApps install (10240=10MB)
# This will allow for some ROM size expansion when GApps are restored
buffer_size_kb=10240

# Parameters passed from updater-script
installing_gapps_type=$1
gapps_size_kb=$2
installing_gapps_version=$3
device_name=$4

# declare starting values
replace_launcher=true
replace_mms=true
replace_browser=true
replace_pico=true

install_chrome=true
install_camera=true

reclaimed_deleted_space_kb=0
reclaimed_browser_space_kb=0
reclaimed_chrome_space_kb=0
reclaimed_gapps_space_kb=0
reclaimed_faceunlock_space_kb=0
reclaimed_camera_space_kb=0
reclaimed_gallery_space_kb=0

# List of files to be deleted or replaced by Chrome
chrome_file_list="/system/app/Chrome.apk
    /system/lib/libchrome.1916.122.so"

# List of files to be deleted or replaced by Google Camera
camera_file_list="/system/app/Camera.apk
    /system/app/Camera2.apk
    /system/app/GoogleCamera.apk
    /system/etc/permissions/com.google.android.camera2.xml
    /system/framework/com.google.android.camera2.jar
    /system/lib/libgcam.so
    /system/lib/libgcam_swig_jni.so
    /system/lib/libjni_tinyplanet.so
    /system/lib/libjpeg.so
    /system/lib/liblightcycle.so
    /system/lib/libnativehelper_compat.so
    /system/lib/librefocus.so
    /system/lib/librs.layered_filter_f32.so
    /system/lib/librsjni.so
    /system/lib/libRSSupport.so
    /system/priv-app/Camera.apk
    /system/priv-app/Camera2.apk"

# List of files to be deleted or replaced by Google Gallery
    gallery_file_list="/system/app/GalleryGoogle.apk
    /system/lib/libjni_eglfence.so
    /system/lib/libjni_filtershow_filters.so
    /system/app/Gallery.apk
    /system/priv-app/Gallery.apk
    /system/app/Gallery2.apk
    /system/priv-app/Gallery2.apk"

# List of files to be deleted or replaced by FaceUnlock
faceunlock_file_list="/system/app/FaceLock.apk
    /system/lib/libfacelock_jni.so
    /system/lib/libfilterpack_facedetect.so
    /system/vendor/pittpatt/models/detection/multi_pose_face_landmark_detectors.7/left_eye-y0-yi45-p0-pi45-r0-ri20.lg_32.bin
    /system/vendor/pittpatt/models/detection/multi_pose_face_landmark_detectors.7/nose_base-y0-yi45-p0-pi45-r0-ri20.lg_32.bin
    /system/vendor/pittpatt/models/detection/multi_pose_face_landmark_detectors.7/right_eye-y0-yi45-p0-pi45-r0-ri20.lg_32-2.bin
    /system/vendor/pittpatt/models/detection/yaw_roll_face_detectors.6/head-y0-yi45-p0-pi45-r0-ri30.4a-v24.bin
    /system/vendor/pittpatt/models/detection/yaw_roll_face_detectors.6/head-y0-yi45-p0-pi45-rn30-ri30.5-v24.bin
    /system/vendor/pittpatt/models/detection/yaw_roll_face_detectors.6/head-y0-yi45-p0-pi45-rp30-ri30.5-v24.bin
    /system/vendor/pittpatt/models/recognition/face.face.y0-y0-22-b-N.bin"

# List of files to be deleted or replaced by Google Now Launcher
launcher_file_list="/system/priv-app/Launcher2.apk
    /system/priv-app/Launcher3.apk
    /system/priv-app/Paclauncher.apk
    /system/priv-app/Trebuchet.apk
    /system/app/Launcher2.apk
    /system/app/Launcher3.apk
    /system/app/Paclauncher.apk
    /system/app/Trebuchet.apk"

# List of files to be deleted or replaced by removing Stock/AOSP Browser
browser_file_list="/system/app/Browser.apk
    /system/app/ChromeBookmarksSyncAdapter.apk"

# List of files to be deleted or replaced by GoogleTTS
picotts_file_list="/system/priv-app/PicoTts.apk
    /system/app/PicoTts.apk
    /system/lib/libttscompat.so
    /system/lib/libttspico.so
    /system/tts/lang_pico"
# ---------------------------------------------------------------------------------------------------------------------

echo -e "# begin Voxive GApps properties\n# This file contains information needed to flash Voxive GApps"  > /tmp/gapps.prop


# Determine if a GApps package is installed - the version, type, and whether it's a PA GApps package
if [ -e /system/priv-app/GoogleServicesFramework.apk ] && [ -e /system/priv-app/GoogleBackupTransport.apk ] && [ -e /system/priv-app/GoogleLoginService.apk ]; then
    if [ -f /system/etc/g.prop ]; then
        if (grep -qi "ro.addon.pa_version=" /system/etc/g.prop ); then
            echo -n "current_gapps_version=" >> /tmp/gapps.prop
            grep "^ro.addon.pa_version" /system/etc/g.prop | cut -d "=" -f2 >> /tmp/gapps.prop
            if (grep -qi "ro.addon.pa_type=" /system/etc/g.prop ); then
                echo -n "current_gapps_type=" >> /tmp/gapps.prop
                grep "^ro.addon.pa_type" /system/etc/g.prop | cut -d "=" -f2 >> /tmp/gapps.prop
            else
                echo "current_gapps_type=unknown" >> /tmp/gapps.prop
            fi
        else
            echo "current_gapps_version=unknown" >> /tmp/gapps.prop
            echo "current_gapps_type=unknown" >> /tmp/gapps.prop
         fi
    else
        echo "current_gapps_version=unknown" >> /tmp/gapps.prop
        echo "current_gapps_type=unknown" >> /tmp/gapps.prop
    fi
else
    echo "current_gapps_version=none" >> /tmp/gapps.prop
    echo "current_gapps_type=none" >> /tmp/gapps.prop
fi

echo "installing_gapps_version=$installing_gapps_version" >> /tmp/gapps.prop
echo -n -e "installing_gapps_type=$installing_gapps_type\ntotal_system_size_kb=" >> /tmp/gapps.prop

# I know it's not pretty, but it does get the job done
df -k system | grep '% /' | tr -cs '0-9' ' ' | sed 's/^[ \t]*//;s/[ \t]*$//' | sed 's/\(.*\) /\1+sys_pct=/' | sed 's/\(.*\) /\1+free_system_size_kb=/' | sed 's/\(.*\) /\1+used_system_size_kb=/' | sed 's/+/\n/g' | sed '/sys_pct/d' >> /tmp/gapps.prop

# Perform storage space calculations of files that are to be deleted
for deleted_file in $(cat /tmp/delete-list.txt)
do
    if [ -e $deleted_file ]; then
        file_size_kb=`du -k "$deleted_file" | cut -f1`
        reclaimed_deleted_space_kb=$(expr $file_size_kb + $reclaimed_deleted_space_kb)
    fi
done

# Check for existence of .gapps-stock in /sdcard for flash modifications
if [ -e /sdcard/.gapps-stock ]; then
    if (grep -qi "launcher" /sdcard/.gapps-stock ); then
        replace_launcher=false
    fi
    if (grep -qi "mms" /sdcard/.gapps-stock ); then
        replace_mms=false
    fi
    if (grep -qi "browser" /sdcard/.gapps-stock ); then
        replace_browser=false
    fi
    if (grep -qi "pico" /sdcard/.gapps-stock ); then
        replace_pico=false
    fi
fi

# Perform storage space calculations if we're removing Stock/AOSP Launcher
if [ $replace_launcher = "true" ]; then
    for launcher_file in $launcher_file_list
    do
    if [ -e $launcher_file ]; then
        file_size_kb=`du -k "$launcher_file" | cut -f1`
        reclaimed_deleted_space_kb=$(expr $file_size_kb + $reclaimed_deleted_space_kb)
    fi
    done
fi

# Perform storage space calculations if we're removing Stock/AOSP MMS App
if [ $replace_mms = "true" ]; then
    if [ -e /system/priv-app/Mms.apk ]; then
        file_size_kb=`du -k "/system/priv-app/Mms.apk" | cut -f1`
        reclaimed_deleted_space_kb=$(expr $file_size_kb + $reclaimed_deleted_space_kb)
    fi
fi

# Perform storage space calculations if we're removing Stock/AOSP Browser
if [ $replace_browser = "true" ]; then
    for browser_file in $browser_file_list
    do
    if [ -e $browser_file ]; then
        file_size_kb=`du -k "$browser_file" | cut -f1`
        reclaimed_browser_space_kb=$(expr $file_size_kb + $reclaimed_browser_space_kb)
    fi
    done
fi

# Perform storage space calculations if we're removing Stock/AOSP PicoTTS
if [ $replace_pico = "true" ]; then
    for picotts_file in $picotts_file_list
    do
    if [ -e $picotts_file ]; then
        file_size_kb=`du -k "$picotts_file" | cut -f1`
        reclaimed_deleted_space_kb=$(expr $file_size_kb + $reclaimed_deleted_space_kb)
    fi
    done
fi

# Perform storage space calculations of GApps Apps we'll be replacing
for gapps_file in $(cat /tmp/gapps-list.txt)
do
    if [ -e $gapps_file ]; then
        file_size_kb=`du -k "$gapps_file" | cut -f1`
        reclaimed_gapps_space_kb=$(expr $file_size_kb + $reclaimed_gapps_space_kb)
    fi
done

# Calculate space saved by removing existing Chrome
for chrome_file in $chrome_file_list
do
if [ -e $chrome_file ]; then
    file_size_kb=`du -k "$chrome_file" | cut -f1`
    reclaimed_chrome_space_kb=$(expr $file_size_kb + $reclaimed_chrome_space_kb)
fi
done

# Does device qualify for FaceUnlock?
good_ffc_device() {
  if [ -f /sdcard/.forcefaceunlock ]; then
    return 0
  fi
  if cat /proc/cpuinfo |grep -q Victory; then
    return 1
  fi
  if cat /proc/cpuinfo |grep -q herring; then
    return 1
  fi
  if cat /proc/cpuinfo |grep -q sun4i; then
    return 1
  fi
  return 0
}

# Final determination to decide if FaceUnlock should be installed
if good_ffc_device && [ -e /system/etc/permissions/android.hardware.camera.front.xml ]; then
    # Calculate space saved by removing existing FaceUnlock files
    for faceunlock_file in $faceunlock_file_list
    do
    if [ -e $faceunlock_file ]; then
        file_size_kb=`du -k "$faceunlock_file" | cut -f1`
        reclaimed_faceunlock_space_kb=$(expr $file_size_kb + $reclaimed_faceunlock_space_kb)
    fi
    done
    inst_fu=true
else
    faceunlock_size_kb=0
    inst_fu=false
fi

# Check for presence of /sdcard/.forcenocamera to bypass installation of Google Camera
if [ -e /sdcard/.forcenocamera ]; then
    install_camera=false
    camera_size_kb=0
fi

# Perform storage space calculations if Google Camera is to be installed
if [ $install_camera = "true" ]; then
    # Calculate space saved by removing existing Stock/AOSP Camera and/or Google Camera
    for camera_file in $camera_file_list
    do
    if [ -e $camera_file ]; then
        file_size_kb=`du -k "$camera_file" | cut -f1`
        reclaimed_camera_space_kb=$(expr $file_size_kb + $reclaimed_camera_space_kb)
    fi
    done
fi

# Here we'll determine if and what type of Google Gallery to install
# .forcenogallery will take precedence over .forcegallery
if [ -e /sdcard/.forcenogallery ]; then
    inst_gallery=false
    gallery_dev=none
elif (grep -qi "hammerhead" /proc/cpuinfo /sdcard/.forcegallery ); then
    inst_gallery=true
    gallery_dev=hammerhead
elif (grep -qi "flo" /proc/cpuinfo /sdcard/.forcegallery ); then
    inst_gallery=true
    gallery_dev=flo
elif (grep -qi "deb" /proc/cpuinfo /sdcard/.forcegallery ); then
    inst_gallery=true
    gallery_dev=deb
elif (grep -qi "mako" /proc/cpuinfo /sdcard/.forcegallery ); then
    inst_gallery=true
    gallery_dev=mako
elif (grep -qi "manta" /proc/cpuinfo /sdcard/.forcegallery ); then
    inst_gallery=true
    gallery_dev=manta
elif (grep -qi "tuna" /proc/cpuinfo /sdcard/.forcegallery ); then
    inst_gallery=true
    gallery_dev=tuna
else
    inst_gallery=false
    gallery_dev=none
fi

# Perform storage space calculations if Google Gallery is to be installed
if [ $inst_gallery = "true" ]; then
    # Calculate space saved by removing existing Stock/AOSP or Google Gallery
    for gallery_file in $gallery_file_list
    do
    if [ -e $gallery_file ]; then
        file_size_kb=`du -k "$gallery_file" | cut -f1`
        reclaimed_gallery_space_kb=$(expr $file_size_kb + $reclaimed_gallery_space_kb)
    fi
    done
else
    gallery_size_kb=0
fi

# Calculate the total amount of system storage required for installation of GApps and options
total_gapps_size_kb=$(expr $gapps_size_kb + $chrome_size_kb + $faceunlock_size_kb + $camera_size_kb + $gallery_size_kb)

# Calculate the amount of 'available' system storage required for installation of GApps and options
free_space_reqd_kb=$(expr $total_gapps_size_kb + $buffer_size_kb - $reclaimed_deleted_space_kb - $reclaimed_browser_space_kb - $reclaimed_gapps_space_kb - $reclaimed_chrome_space_kb - $reclaimed_faceunlock_space_kb - $reclaimed_camera_space_kb - $reclaimed_gallery_space_kb)
free_system_space_kb=`grep "^free_system_size_kb" /tmp/gapps.prop | cut -d "=" -f2`
if [ "$free_space_reqd_kb" -le 0 ]; then
    free_space_reqd_kb=0
elif [ "$free_space_reqd_kb" -gt "$free_system_space_kb" ]; then
    # we don't have enough system space to install the full package - and we won't install Chrome or remove Stock/AOSP browser
    free_space_reqd_kb=$(expr $free_space_reqd_kb - $chrome_size_kb + $reclaimed_browser_space_kb)
    if [ "$free_space_reqd_kb" -le 0 ]; then
        free_space_reqd_kb=0
    fi
    total_gapps_size_kb=$(expr $total_gapps_size_kb - $chrome_size_kb)
    echo "Browser" >> /sdcard/.gapps-stock
    install_chrome=false
    replace_browser=false
fi

echo "free_space_reqd_kb=$free_space_reqd_kb" >> /tmp/gapps.prop
echo "total_gapps_size_kb=$total_gapps_size_kb" >> /tmp/gapps.prop
echo "install.chrome=$install_chrome" >> /tmp/gapps.prop
echo "install.faceunlock=$inst_fu" >> /tmp/gapps.prop
echo "install.camera=$install_camera" >> /tmp/gapps.prop
echo "install.gallery=$inst_gallery" >> /tmp/gapps.prop
echo "gallery.device=$gallery_dev" >> /tmp/gapps.prop
echo "replace.launcher=$replace_launcher" >> /tmp/gapps.prop
echo "replace.mms=$replace_mms" >> /tmp/gapps.prop
echo "replace.browser=$replace_browser" >> /tmp/gapps.prop
echo "replace.picotts=$replace_pico" >> /tmp/gapps.prop
echo "device.name=$device_name" >> /tmp/gapps.prop
echo "# end Voxive GApps properties" >> /tmp/gapps.prop

# Copy gapps.prop to the SDCard as 'gapps.log'
cp -af /tmp/gapps.prop /sdcard/Voxive/gapps.log
