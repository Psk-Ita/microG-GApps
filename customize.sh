
apitest() 
{
	pm install --dont-kill "$MODPATH/system/priv-app/GmsCore/com.google.android.gms.apk"
    return expr 30 - $API
}


if apitest; then
	rm -r "$MODPATH/system/priv-app/Phonesky"
else 
	rm -r "$MODPATH/system/priv-app/Vending"
fi
