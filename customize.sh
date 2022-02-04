
apitest() 
{
    return expr 30 - $API
}


if apitest; then
	rm -r "$MODPATH/system/priv-app/Phonesky"
else 
	rm -r "$MODPATH/system/priv-app/Vending"
fi
