#!/bin/bash
echo "  ____________________________________________________ "
echo " |                                                    | "
echo " |    Play Store settings...                          | "
if [ $API -gt 30 ]; then
  mv "$MODPATH/system/etc/permissions/phonesky.permissions.xml" "$MODPATH/system/etc/permissions/com.android.vending.xml"
  rm "$MODPATH/system/etc/permissions/vending.permissions.xml"
  rm -r "$MODPATH/system/priv-app/Vending"
else
  mv "$MODPATH/system/etc/permissions/vending.permissions.xml" "$MODPATH/system/etc/permissions/com.android.vending.xml"
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

echo " |                                                    | "
echo " |    downloading microG Services Core...             | "
mkdir "$MODPATH/system/priv-app/gms"
$curl -o "$MODPATH/system/priv-app/gms/base.apk" -k "https://microg.org/fdroid/repo/com.google.android.gms-233013058.apk"
echo " |                                                    | "
install -r "$MODPATH/system/priv-app/gms/base.apk"
for i in $( ls -d '/data/app/*/*gms*' );
do
  mv -rf $1 $MODPATH/system/priv-app/gms
done

echo " |    downloading microG Services Framework Proxy...  | "
mkdir "$MODPATH/system/priv-app/gsf"
$curl -o "$MODPATH/system/priv-app/gsf/base.apk" -k "https://microg.org/fdroid/repo/com.google.android.gsf-8.apk"
echo " |                                                    | "
echo " |    Enjoy!                                          | "
echo " |____________________________________________________| "
echo

rm -r "$MODPATH/tools"
