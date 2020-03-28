#!/bin/sh

alias PlistBuddy=/usr/libexec/PlistBuddy
plist=/Library/Preferences/com.apple.Bluetooth.plist

delete () {
    PlistBuddy -c "Delete :DeviceCache:$addr:$1" $plist &> /dev/null
}

echo "Available devices:"
for addr in `PlistBuddy -c "Print :DeviceCache" $plist | grep -ao "..-..-..-..-..-.."`
do
    echo "$addr: `PlistBuddy -c \"Print :DeviceCache:$addr:Name\" $plist`"
done
read -p "Address: " addr

cp $plist $plist.backup

delete ClassOfDevice
delete ClockOffset
delete InquiryRSSI
delete LastServiceUpdate
delete Manufacturer
delete PageScanMode
delete PageScanPeriod
delete PageScanRepetitionMode
delete ProductID
delete Services
delete SupportedFeatures
delete VendorID

macOS_ver=$(sw_vers -productVersion)

if [[ $macOS_ver == 10.15.* ]]
then
    PlistBuddy -c "Merge Controller-catalina.plist :DeviceCache:$addr" $plist
else
    PlistBuddy -c "Merge Controller.plist :DeviceCache:$addr" $plist
fi

defaults read $plist &> /dev/null

echo "Done."