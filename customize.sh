#!/bin/bash

gms = (pm list package | grep 'com.google.android.gms' | wc -l)
if [ $gms -gt 1 ]; then
  pm install "$MODPATH/system/priv-app/GmsCore/com.google.android.gms.apk"
fi

if [ $API -gt 30 ]; then
  rm -r "$MODPATH/system/priv-app/Vending"
else
  rm -r "$MODPATH/system/priv-app/Phonesky"
fi
