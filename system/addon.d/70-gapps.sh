#!/sbin/sh
# 
# /system/addon.d/70-gapps.sh
#
. /tmp/backuptool.functions

list_files() {
cat <<EOF
app/Books.apk
app/CalendarGoogle.apk
app/CloudPrint2.apk
app/Drive.apk
app/GenieWidget.apk
app/Gmail2.apk
app/GoogleContactsSyncAdapter.apk
app/GoogleEars.apk
app/GoogleEarth.apk
app/GoogleHome.apk
app/GoogleTTS.apk
app/Hangouts.apk
app/Keep.apk
app/LatinImeGoogle.apk
app/Magazines.apk
app/Maps.apk
app/Music2.apk
app/PlayGames.apk
app/PlusOne.apk
app/QuickOffice.apk
app/Street.apk
app/SunBeam.apk
app/Videos.apk
app/YouTube.apk
etc/g.prop
etc/permissions/com.google.android.camera2.xml
etc/permissions/com.google.android.maps.xml
etc/permissions/com.google.android.media.effects.xml
etc/permissions/com.google.widevine.software.drm.xml
etc/permissions/features.xml
etc/preferred-apps/google.xml
framework/com.google.android.camera2.jar
framework/com.google.android.maps.jar
framework/com.google.android.media.effects.jar
framework/com.google.widevine.software.drm.jar
lib/libAppDataSearch.so
lib/libcrashreporter.so
lib/libdocscanner_image.so
lib/libdocsimageutils.so
lib/libearthandroid.so
lib/libearthmobile.so
lib/libfilterframework_jni.so
lib/libframesequence.so
lib/libgames_rtmp_jni.so
lib/libgmm-jni.so
lib/libgoogle_hotword_jni.so
lib/libgoogle_recognizer_jni_l.so
lib/libjni_latinime.so
lib/libjni_t13n_shared_engine.so
lib/libjni_unbundled_latinimegoogle.so
lib/libmoviemaker-jni.so
lib/libnetjni.so
lib/libocrclient.so
lib/libpatts_engine_jni_api_ub.210030011.so
lib/libphotoeditor_native.so
lib/librectifier.so
lib/libspeexwrapper.so
lib/libvcdecoder_jni.so
lib/libvideochat_jni.so
lib/libvorbisencoder.so
lib/libwebp_android.so
lib/libWVphoneAPI.so
priv-app/CalendarProvider.apk
priv-app/GoogleBackupTransport.apk
priv-app/GoogleFeedback.apk
priv-app/GoogleLoginService.apk
priv-app/GoogleOneTimeInitializer.apk
priv-app/GooglePartnerSetup.apk
priv-app/GoogleServicesFramework.apk
priv-app/Phonesky.apk
priv-app/PrebuiltGmsCore.apk
priv-app/SetupWizard.apk
priv-app/talkback.apk
priv-app/Velvet.apk
priv-app/Wallet.apk
usr/srec/en-US/c_fst
usr/srec/en-US/clg
usr/srec/en-US/commands.abnf
usr/srec/en-US/compile_grammar.config
usr/srec/en-US/contacts.abnf
usr/srec/en-US/dict
usr/srec/en-US/dictation.config
usr/srec/en-US/dnn
usr/srec/en-US/endpointer_dictation.config
usr/srec/en-US/endpointer_voicesearch.config
usr/srec/en-US/ep_acoustic_model
usr/srec/en-US/g2p_fst
usr/srec/en-US/grammar.config
usr/srec/en-US/hclg_shotword
usr/srec/en-US/hmm_symbols
usr/srec/en-US/hmmlist
usr/srec/en-US/hotword.config
usr/srec/en-US/hotword_classifier
usr/srec/en-US/hotword_normalizer
usr/srec/en-US/hotword_prompt.txt
usr/srec/en-US/hotword_word_symbols
usr/srec/en-US/metadata
usr/srec/en-US/norm_fst
usr/srec/en-US/normalizer
usr/srec/en-US/offensive_word_normalizer
usr/srec/en-US/phone_state_map
usr/srec/en-US/phonelist
usr/srec/en-US/rescoring_lm
usr/srec/en-US/wordlist
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
    # Additional ROM/AOSP Removals from GApps Remover

    # Check for existence of .gapps-stock in /sdcard for flash modifications
    if [ -e /sdcard/.gapps-stock ]; then
        if ! (grep -qi "launcher" /sdcard/.gapps-stock ); then
            # Remove the stock/AOSP Launcher
            rm -f /system/priv-app/Launcher2.apk
            rm -f /system/priv-app/Launcher3.apk
            rm -f /system/priv-app/Paclauncher.apk
            rm -f /system/priv-app/Trebuchet.apk
            rm -f /system/app/Launcher2.apk
            rm -f /system/app/Launcher3.apk
            rm -f /system/app/Paclauncher.apk
            rm -f /system/app/Trebuchet.apk
        fi
        if ! (grep -qi "mms" /sdcard/.gapps-stock ); then
            # Remove the stock/AOSP MMS app
            rm -f /system/priv-app/Mms.apk
        fi
        if ! (grep -qi "pico" /sdcard/.gapps-stock ); then
            # Remove the stock/AOSP PicoTTS
            rm -f /system/priv-app/PicoTts.apk
            rm -f /system/app/PicoTts.apk
            rm -f /system/lib/libttscompat.so
            rm -f /system/lib/libttspico.so
            rm -rf /system/tts/lang_pico/*
        fi        
    else
        # Remove the stock/AOSP Launcher
        rm -f /system/priv-app/Launcher2.apk
        rm -f /system/priv-app/Launcher3.apk
        rm -f /system/priv-app/Paclauncher.apk
        rm -f /system/priv-app/Trebuchet.apk
        rm -f /system/app/Launcher2.apk
        rm -f /system/app/Launcher3.apk
        rm -f /system/app/Paclauncher.apk
        rm -f /system/app/Trebuchet.apk
  
        # Remove the stock/AOSP MMS app
        rm -f /system/priv-app/Mms.apk
        
        # Remove the stock/AOSP PicoTTS
        rm -f /system/priv-app/PicoTts.apk
        rm -f /system/app/PicoTts.apk
        rm -f /system/lib/libttscompat.so
        rm -f /system/lib/libttspico.so
        rm -rf /system/tts/lang_pico/*
    fi
  
    # Remove the stock/AOSP Keyboard
    rm -f /system/app/LatinIME.apk
    rm -f /system/lib/libjni_latinimegoogle.so

    # Removing 'Rogue' Keyboard app found in Velocity (and possibly other) ROM's
    rm -f /system/app/GoogleLatinIme.apk

    # Remove pieces from other GApps or ROM's (from updater-script)
    rm -f /system/app/BrowserProviderProxy.apk
    rm -f /system/app/Calendar.apk
    rm -f /system/app/Gmail.apk
    rm -f /system/app/GmsCore.apk
    rm -f /system/app/GoogleCalendar.apk
    rm -f /system/app/GoogleCalendarSyncAdapter.apk
    rm -f /system/app/GoogleCloudPrint.apk
    rm -f /system/app/GoogleHangouts.apk
    rm -f /system/app/GoogleKeep.apk
    rm -f /system/app/GooglePlus.apk
    rm -f /system/app/PartnerBookmarksProvider.apk
    rm -f /system/app/QuickSearchBox.apk
    rm -f /system/app/Talk.apk
    rm -f /system/app/Vending.apk
    rm -f /system/app/Youtube.apk
    rm -f /system/priv-app/Calendar.apk
    rm -f /system/priv-app/GmsCore.apk
    rm -f /system/priv-app/GoogleNow.apk
    rm -f /system/priv-app/OneTimeInitializer.apk
    rm -f /system/priv-app/QuickSearchBox.apk
    rm -f /system/priv-app/Vending.apk

    # Remove apps from 'app' that need to be installed in 'priv-app' (from updater-script)
    rm -f /system/app/CalendarProvider.apk
    rm -f /system/app/GoogleBackupTransport.apk
    rm -f /system/app/GoogleFeedback.apk
    rm -f /system/app/GoogleLoginService.apk
    rm -f /system/app/GoogleOneTimeInitializer.apk
    rm -f /system/app/GooglePartnerSetup.apk
    rm -f /system/app/GoogleServicesFramework.apk
    rm -f /system/app/OneTimeInitializer.apk
    rm -f /system/app/Phonesky.apk
    rm -f /system/app/PrebuiltGmsCore.apk
    rm -f /system/app/SetupWizard.apk
    rm -f /system/app/talkback.apk
    rm -f /system/app/Velvet.apk
    rm -f /system/app/Wallet.apk
  ;;
  post-restore)
    # Stub
  ;;
esac
