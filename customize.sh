if [ $API -gt 30 ]; then
  rm -r "$MODPATH/system/priv-app/Vending"
else
  rm -r "$MODPATH/system/priv-app/Phonesky"
fi
