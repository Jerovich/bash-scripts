#!/bin/bash

clear

sudo apt update > /dev/null

list=`sudo apt list --upgradable | grep -v Listing`

IFS=$'\n'
for j in $(sudo apt list --upgradable | grep upgradable)
do
	echo "$j"
done

if [ -z $j ]; then
	echo All packages are up to date.; echo
	exit 0
else
	echo; echo 'Do you want to proceed? (y/n)'; echo
fi

i=0
while [ $i -lt 3 ]; do
  read -s -n 1 option
  if [ $option = y ]; then
    sudo apt full-upgrade -y
    sudo apt autoremove -y
    echo; echo 'Finished'; echo
    exit 0
    elif [ $option = n ]; then
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
