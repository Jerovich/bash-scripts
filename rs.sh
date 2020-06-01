#!/bin/bash

HOMEDIR="/home/user/"
BACKUPDIR="/mnt/Backup"
SOURCEDIR="/home/user/dir"
USBDIR="/mnt/USB"

USB_PARAM="--delete --exclude .directory"
BAK_PARAM="--delete --exclude .cache  --exclude Scripts/tmp"

TEMP_FILE="/home/user/Scripts/tmp/rsusb_deleting.txt"

clear

if [ ! -d /home/user/Scripts/tmp/ ]; then
  mkdir -p /home/user/Scripts/tmp/
fi

echo; echo 'Please select one of these options:'; echo
echo '[1] Synchronize Modules/ from USB to HOME'
echo '[2] Synchronize Modules/ from HOME to USB'
echo '[3] Backup HOME partition'
echo
echo '[4] Cancel synchronization'; echo

i=0
while [ $i -lt 3 ]; do
  read -s -n 1 OPTION
  if [ $OPTION = 1 ]; then
    DEST_DIR="your HOME partition"
    PROCEED="rsync -aivuh $USB_PARAM $USBDIR $SOURCEDIR"
    rsync -naivuh $USB_PARAM $USBDIR $SOURCEDIR | grep '*deleting   ' > $TEMP_FILE
    break
  elif [ $OPTION = 2 ]; then
    DEST_DIR="your USB"
    PROCEED="rsync -aivuh $USB_PARAM $SOURCEDIR $USBDIR"
    rsync -naivuh $USB_PARAM $SOURCEDIR $USBDIR | grep '*deleting   ' > $TEMP_FILE
    break
  elif [ $OPTION = 3 ]; then
    DEST_DIR="your BACKUP partition"
    PROCEED="sudo rsync -aivuh $BAK_PARAM $HOMEDIR $BACKUPDIR"
    sudo rsync -naivuh $BAK_PARAM $HOMEDIR $BACKUPDIR | grep '*deleting   ' > $TEMP_FILE
    break
  elif [ $OPTION = 4 ]; then
    echo 'Cancelled'; echo
    exit 0
  elif [ $i -lt 2 ]; then
    i=$(( $i + 1))
    echo 'Please enter "1", "2" or "3"'; echo
  else
    echo 'Repeat with me...'; echo
    sleep 1.5
    echo '"1", "2" or "3"...'; echo
    sleep 1.5
    echo 'Got it?'; echo
    sleep 1.5
    exit 0
  fi
done

grep '*deleting   ' $TEMP_FILE > /dev/null

if [ $? = 0 ]; then
  echo "Following files will be deleted in $DEST_DIR:"; echo
  sed 's/\*deleting   //' $TEMP_FILE | less
else
  echo "No files will be deleted in $DEST_DIR."
fi

rm $TEMP_FILE
echo; echo 'Do you want to proceed? (y/n)'; echo

i=0
while [ $i -lt 3 ]; do
  read -s -n 1 OPTION
  if [ $OPTION = y ]; then
    $PROCEED
    echo; echo 'Finished'; echo
    exit 0
    elif [ $OPTION = n ]; then
    echo 'Cancelled'; echo
    exit 0
    elif [ $i -lt 2 ]; then
    i=$(( $i + 1))
    echo "Please enter \"y\" or \"n\""; echo
  else
    echo "It's not that difficult to enter \"y\" or \"n\"..."; echo
    sleep 1.5
    echo "isn't it?"; echo
    sleep 1.5
    exit 0
  fi
done
