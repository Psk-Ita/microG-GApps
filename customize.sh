#!/bin/bash

if [ $ARCH = "arm" ]; then
    # 32-bit
    curl=$MODPATH/tools/curl/arm64eabi-v7a/curl
else
    # 64-bit
    curl=$MODPATH/tools/curl/arm64-v8a/curl
fi
chmod 777 $curl

gms=com.google.android.gms
gsf=com.google.android.gsf

tmp=/data/local/tmp
mkdir $tmp

echo " _________________________________________________ "
echo "                                                   "

gmsTo=true
echo "   microG Services Core...                         "
for i in $(pm path $gms | grep /data/app); do
  gmsTo=false
  am force-stop $gms >> $MODPATH/$gms.txt &2>> $MODPATH/$gms.txt
done

if $gmsTo; then
  echo -n "     downloading                              "
  $curl -o "$tmp/$gms.apk" -k "https://microg.org/fdroid/repo/$gms-233013058.apk"
  echo "Done "
  
  echo -n "     installing                            "
  pm install --user 0 $tmp/$gms.apk
else
  echo "     already installed                             "
fi

echo "                                                   "

gsfTo=true
echo "   microG Services Proxy...                        "
for i in $(pm path $gsf | grep /data/app); do
  gsfTo=false
  am force-stop $gsf >> $MODPATH/$gsf.txt &2>> $MODPATH/$gsf.txt
done

if $gsfTo; then
  echo -n "     downloading                              "
  $curl -o "$tmp/$gsf.apk" -k "https://microg.org/fdroid/repo/$gsf-8.apk"
  echo "Done "
  
  echo -n "     installing                            "
  pm install --user 0 $tmp/$gsf.apk
else
  echo "     already installed                             "
fi

echo "                                                   "
echo "   Play Store...                                   "
if [ $API -gt 30 ]; then
  mv "$MODPATH/system/etc/permissions/phonesky.permissions.xml" "$MODPATH/system/etc/permissions/com.android.vending.xml"
  rm "$MODPATH/system/etc/permissions/vending.permissions.xml"
  rm -r "$MODPATH/system/priv-app/Vending"
else
  mv "$MODPATH/system/etc/permissions/vending.permissions.xml" "$MODPATH/system/etc/permissions/com.android.vending.xml"
  rm "$MODPATH/system/etc/permissions/phonesky.permissions.xml"
  rm -r "$MODPATH/system/priv-app/Phonesky"
fi

echo "                                                   "
echo "   Systemizing...                                  "

cd /data/app/

for i in $(ls -d /data/app/*/$gms-*); do
  mv $i $MODPATH/system/priv-app/microGServicesCore
done

for i in $(ls -d /data/app/*/$gsf-*); do
  mv $i $MODPATH/system/priv-app/microGFrameworkProxy
done

rm "$tmp/$gsf.apk"
rm "$tmp/$gms.apk"
rm "$MODPATH/$gsf.txt"
rm "$MODPATH/$gms.txt"
rm -rf "$MODPATH/tools"

echo "                                                   "
echo "   Enjoy!                                          "
echo " _________________________________________________ "
echo
