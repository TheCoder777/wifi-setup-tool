#!/bin/env bash

CBOLD='\033[1m'
CITALIC='\033[3m'
CRED2='\033[91m'
CGREEN2='\033[92m'
CEND='\033[0m'

wifi_interface="wlan0" #change that to your personal needs (output of 'ip -a')

ssid="FRITZ!Box 7490" #personal settings for default connection
passwd="91151209986001541952"

if [ -z "$1" ]; then
	echo -n "setting up wifi..."
	out=$(nmcli device wifi connect "$ssid" password "$passwd")
	echo -n -e "${CGREEN2}${CBOLD}done!${CEND}\n"
	echo $out
	exit
elif [ "$1" == "-c" -o "$1" == "--custom" ]; then
	echo Choose ssid name:
	nmcli device wifi list && echo -n "> "
	read ssid_name
	echo "Insert password: (if no password, leaf empty)"
	read password
	echo -n "connecting..."
	if [ -z "$password" ]; then #if no password needed
		out=$(nmcli device wifi connect "$ssid_name")
		if [ ! $? == 0 ]; then #if command fails
			echo -n -e "${CRED2}${CBOLD}connecting failed!${CEND}\n"
			exit
		else #if command succeed
			echo -n -e "${CGREEN2}${CBOLD}done!${CEND}\n"
			echo $out
			exit
		fi
		exit

	else #if passoword is given
		out=$(nmcli device wifi connect "$ssid_name" password "$password")
		if [ ! $? == 0 ]; then #if command fails
			echo -n -e "${CRED2}${CBOLD}connecting failed!${CEND}\n"
			exit
		else #if command succeed
			echo -n -e "${CGREEN2}${CBOLD}done!${CEND}\n"
			echo $out
			exit
		fi
		exit
	fi

elif [ "$1" == "-d" -o "$1" == "--disconnect" ]; then
	echo -n "disconnecting..."
	out=$(nmcli device disconnect "${wifi_interface}")
	if [ ! $? == 0 ]; then #if command fails
		echo -n -e "${CRED2}${CBOLD}disconnect failed!${CEND}\n"
		exit
	else #if command succeed
		echo -n -e "${CGREEN2}${CBOLD}done!${CEND}\n"
		echo $out
		exit
	fi
	exit

elif [ "$1" == "-h" -o "$1" == "--help" ]; then
	echo -n -e "\n${CITALIC}Simple Interface for nmcli!${CEND}\n\n"
	echo -n -e "${CBOLD}USAGE:${CEND}\n"
	echo -e "setupwifi [OPTIONS]\n\n"
	echo -n -e "${CBOLD}Options:${CEND}\n"
	echo "-h / --help		Print this help dialog."
	echo "-c / --custom		Specify custom ssid and password."
	echo "-d / --disconnect	Disconnect from current network."
	echo
	echo -e "${CITALIC}By default, personal Profile is used!${CEND}\n"
	exit
fi
