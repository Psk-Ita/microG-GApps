#!/bin/bash

tmp=/data/local/tmp
gms=com.google.android.gms
gsf=com.google.android.gsf

echo " _________________________________________________ "
echo "|                                                 |"
echo "|  Play Store settings...                         |"
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

mkdir $tmp
cd $tmp

am force-stop $gms >> $MODPATH/$gms.txt &2>> $MODPATH/$gms.txt
am force-stop $gsf >> $MODPATH/$gsf.txt &2>> $MODPATH/$gsf.txt

echo "|                                                 |"
echo "|  downloading:                                   |"
echo "|      microG Services Core...                    |"
$curl -o "$tmp/$gms.apk" -k "https://microg.org/fdroid/repo/$gms-233013058.apk" &
echo "|      microG Services Framework Proxy...         |"
$curl -o "$tmp/$gsf.apk" -k "https://microg.org/fdroid/repo/$gsf-8.apk" &
wait
sleep 1

echo "|                                                 |"
echo "|  installing:                                    |"

echo -n "|      microG Services Core...            "
pm install -r --user 0 $tmp/$gms.apk &
wait

echo -n "|      microG Services Framework Proxy... "
pm install -r --user 0 $tmp/$gsf.apk &
wait
sleep 1

echo "|                                                 |"
echo "|  systemizing:                                   |"
echo "|      microG Services Core...                    |"
for i in $(ls -d /data/app/*/$gms-*); do
  mv "$i" "$MODPATH/system/priv-app"
done

# echo "|                                                 |"
echo "|      microG Services Framework Proxy...         |"
for i in $(ls -d /data/app/*/$gsf-*); do
  mv "$i" "$MODPATH/system/priv-app"
done

rm "$tmp/$gsf.apk"
rm "$tmp/$gms.apk"
rm "$MODPATH/$gsf.txt"
rm "$MODPATH/$gms.txt"
rm -rf "$MODPATH/tools"
# rm -rf "$MODPATH/apks"

echo "|                                                 |"
echo "|  Enjoy!                                         |"
echo "|_________________________________________________|"
echo