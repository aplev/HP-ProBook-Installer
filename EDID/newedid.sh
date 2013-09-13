#!/bin/bash
# HP ProBook 4x30s EDID generator by Philip Petev v6.3
GenEDID () {
/usr/libexec/PlistBuddy -c "Print :$1" /tmp/display.plist
if [ $? -eq 0 ]
then
	RegName=`/usr/libexec/PlistBuddy -c "Print :$1:IORegistryEntryName" /tmp/display.plist`
	DisplayFlags=`/usr/libexec/PlistBuddy -c "Print :$1:IODisplayConnectFlags" /tmp/display.plist`
	VenID=`/usr/libexec/PlistBuddy -c "Print :$1:DisplayVendorID" /tmp/display.plist`
	VenIDhex=`printf '%x\n' $VenID`
	ProdID=`/usr/libexec/PlistBuddy -c "Print :$1:DisplayProductID" /tmp/display.plist`
	ProdIDhex=`printf '%x\n' $ProdID`
	GenDir="$DSTVOLUME/System/Library/Displays/Overrides/DisplayVendorID-$VenIDhex"
	GenFile="DisplayProductID-$ProdIDhex"
	if [ "$RegName" == "AppleBacklightDisplay" -o "$DisplayFlags" == "`echo AAgAAA== | base64 -D`" ]
	then
		if [ ! -e "$GenDir" ]
		then
			mkdir "$GenDir"
		fi
		/usr/libexec/PlistBuddy -c "Add :DisplayProductName string 'ProBook 4x30s'" "$GenDir/$GenFile"
		/usr/libexec/PlistBuddy -c "Add :test array" "$GenDir/$GenFile"
		/usr/libexec/PlistBuddy -c "Merge /tmp/display.plist :test" "$GenDir/$GenFile"
		/usr/libexec/PlistBuddy -c "Copy :test:$1:DisplayProductID :DisplayProductID" "$GenDir/$GenFile"
		/usr/libexec/PlistBuddy -c "Copy :test:$1:DisplayVendorID :DisplayVendorID" "$GenDir/$GenFile"
		/usr/libexec/PlistBuddy -c "Copy :test:$1:IODisplayEDID :IODisplayEDID" "$GenDir/$GenFile"
		/usr/libexec/PlistBuddy -c "Remove :test" "$GenDir/$GenFile"
		chown -R root:wheel "$GenDir" && chmod 755 "$GenDir" && chmod 644 "$GenDir/$GenFile"
	else
		echo "External display detected!"
	fi
else
	echo "No display detected!"
fi	
}
if [ -e /tmp/display.plist ]
then
	rm -rf /tmp/display.plist
fi
case `./ioregpbi -n AppleBacklightDisplay -rxw0` in
	"")	./ioregpbi -n AppleDisplay -arxw0 > /tmp/display.plist
		;;
	*) ./ioregpbi -n AppleBacklightDisplay -arxw0 > /tmp/display.plist
		;;
esac
GenEDID 0 && GenEDID 1 && GenEDID 2
rm -rf /tmp/display.plist