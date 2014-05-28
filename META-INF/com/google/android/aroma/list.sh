# _____________________________________________________________________________________________________________________
#                                             Standard Google Apps List
std_remove_list="Books
                Calendar
                CloudPrint
                Drive
                Ears
                Earth
                Gmail
                GNow
                GoogleTTS
                GPlus
                Hangouts
                Keep
                Maps
                Movies
                Music
                NewsStand
                NewsWidget
                PlayGames
                QuickOffice
                Search
                Street
                Sunbeam
                Talkback
                Wallet
                YouTube"
# _____________________________________________________________________________________________________________________
#                                             Standard Google Apps File List (/system/app)
Books_list="app/Books.apk"

Calendar_list="app/CalendarGoogle.apk"

CloudPrint_list="app/CloudPrint2.apk"

Drive_list="app/Drive.apk
            lib/librectifier.so
            lib/libdocscanner_image.so
            lib/libdocsimageutils.so"

Ears_list="app/GoogleEars.apk
            lib/libvorbisencoder.so"

Earth_list="app/GoogleEarth.apk
            lib/libearthandroid.so
            lib/libearthmobile.so"

Gmail_list="app/Gmail2.apk"

GNow_list="app/GoogleHome.apk"

GoogleTTS_list="app/GoogleTTS.apk
            lib/libpatts_engine_jni_api_ub.210030011.so
            lib/libspeexwrapper.so"

GPlus_list="app/PlusOne.apk
            lib/libwebp_android.so
            lib/libfilterframework_jni.so
            lib/libmoviemaker-jni.so
            lib/libnetjni.so
            lib/libphotoeditor_native.so"

Hangouts_list="app/Hangouts.apk
            lib/libframesequence.so
            lib/libvideochat_jni.so"

Keep_list="app/Keep.apk"

Maps_list="app/Maps.apk
            lib/libgmm-jni.so"

Movies_list="app/Videos.apk
            lib/libWVphoneAPI.so"

Music_list="app/Music2.apk"

NewsStand_list="app/Magazines.apk"

NewsWidget_list="app/GenieWidget.apk"

PlayGames_list="app/PlayGames.apk"

QuickOffice_list="app/QuickOffice.apk"

Street_list="app/Street.apk"

Sunbeam_list="app/SunBeam.apk"

YouTube_list="app/YouTube.apk"
# _____________________________________________________________________________________________________________________
#                                             Standard Google Apps File List (/system/priv-app)
Search_list="priv-app/Velvet.apk
            lib/libgoogle_hotword_jni.so
            lib/libgoogle_recognizer_jni_l.so
            lib/libvcdecoder_jni.so
            app/GoogleHome.apk"

Talkback_list="priv-app/talkback.apk"

Wallet_list="priv-app/Wallet.apk"
# _____________________________________________________________________________________________________________________
#                                             Optional Google Apps File List
opt_remove_list="Chrome
                FaceUnlock
                GGallery"
# _____________________________________________________________________________________________________________________
#                                             Optional Google Apps File List
Chrome_list="app/Chrome.apk
            lib/libchrome.1916.122.so
            addon.d/78-chromebrowser.sh"

FaceUnlock_list="app/FaceLock.apk
            lib/libfacelock_jni.so
            lib/libfilterpack_facedetect.so
            vendor/pittpatt/models/detection/multi_pose_face_landmark_detectors.7/left_eye-y0-yi45-p0-pi45-r0-ri20.lg_32.bin
            vendor/pittpatt/models/detection/multi_pose_face_landmark_detectors.7/nose_base-y0-yi45-p0-pi45-r0-ri20.lg_32.bin
            vendor/pittpatt/models/detection/multi_pose_face_landmark_detectors.7/right_eye-y0-yi45-p0-pi45-r0-ri20.lg_32-2.bin
            vendor/pittpatt/models/detection/yaw_roll_face_detectors.6/head-y0-yi45-p0-pi45-r0-ri30.4a-v24.bin
            vendor/pittpatt/models/detection/yaw_roll_face_detectors.6/head-y0-yi45-p0-pi45-rn30-ri30.5-v24.bin
            vendor/pittpatt/models/detection/yaw_roll_face_detectors.6/head-y0-yi45-p0-pi45-rp30-ri30.5-v24.bin
            vendor/pittpatt/models/recognition/face.face.y0-y0-22-b-N.bin
            addon.d/71-faceunlock.sh"

GGallery_list="app/GalleryGoogle.apk
            lib/libjni_eglfence.so
            lib/libjni_filtershow_filters.so
            addon.d/75-googlegallery.sh"
# _____________________________________________________________________________________________________________________
#                                             Define Variables

gapps_remove=/sdcard/.gapps-remove

# _____________________________________________________________________________________________________________________
#                                             Applications Removal Process
# Perform the Standard GApps application removals [and remove from /system/addon.d/70-gapps.sh]
for std_name in $std_remove_list
do
if (grep -qi $std_name "$gapps_remove" ); then
    eval "list_name=\$${std_name}_list"
    for file_name in $list_name
    do
        rm -f /system/$file_name
        sed -i "\:${file_name}:d" /system/addon.d/70-gapps.sh
    done
fi
done

# Perform the Optional GApps application removals [with NO addon.d modifications]
for opt_name in $opt_remove_list
do
if (grep -qi $opt_name "$gapps_remove" ); then
    eval "list_name=\$${opt_name}_list"
    for file_name in $list_name
    do
        rm -f /system/$file_name
    done
fi
done
