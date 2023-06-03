#!/bin/bash

mkdir -p $TMPDIR
[ -f "$MODPATH/tools/tools.tar.xz" ] && tar -xvf $MODPATH/tools/tools.tar.xz -C $MODPATH/tools > /dev/null


if [ $API -gt 30 ]; then
  rm "$MODPATH/system/etc/permissions/vending.permissions.xml"
  rm -r "$MODPATH/system/priv-app/Vending"
else
  rm "$MODPATH/system/etc/permissions/phonesky.permissions.xml"
  rm -r "$MODPATH/system/priv-app/Phonesky"
fi

if [ $ARCH = "arm" ]; then
    # 32-bit
    curl=$MODPATH/tools/curl/arm64eabi-v7a/curl
else
    # 64-bit
    curl=$MODPATH/tools/curl/arm64-v8a/curl
fi

chmod 777 $curl

mkdir "$MODPATH/system/priv-app/GoogleServicesCore"
echo downloading Services Core from microG...
$curl -o "$MODPATH/system/priv-app/GoogleServicesCore/base.apk" -k "https://microg.org/fdroid/repo/com.google.android.gms-231657056.apk"

mkdir "$MODPATH/system/priv-app/ServicesFrameworkProxy"
echo downloading Services Framework from microG...
$curl -o "$MODPATH/system/priv-app/ServicesFrameworkProxy/base.apk" -k "https://microg.org/fdroid/repo/com.google.android.gsf-8.apk"

