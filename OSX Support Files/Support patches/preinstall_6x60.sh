#!/bin/bash
set -x
osxver=`/usr/libexec/PlistBuddy -c 'Print ProductVersion' "${3}"/System/Library/CoreServices/SystemVersion.plist`
case $osxver in
10.7*)	echo "OS X Lion $osxver detected."
		./Backup.sh ./list_6x60l "${3}"
		;;
10.8*)	echo "OS X Mountain Lion $osxver detected."
		./Backup.sh ./list_6x60ml "${3}"
		;;
10.9*)	echo "OS X Mavericks $osxver detected."
		./Backup.sh ./list_6x60ml "${3}"
		;;
*)		echo "Unknown or unsupported OS X version, aborting."
		;;
esac