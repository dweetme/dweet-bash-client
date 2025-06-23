#Copyright (c) 2025 dweet.me
#!/bin/bash

# Enable color formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
RESET='\033[0m'

DWEET_SERVER='https://dweet.me:3334'

if ! command -v curl &> /dev/null; then
	echo -e "${RED}Error: 'curl' is not installed. This script needs it to run. Please install it and try again.${RESET}"
	exit 1
fi

if ! command -v jq &> /dev/null; then
	echo -e "${YELLOW}Warn: 'jq' is not installed. It pretties up json well, I'd consider installing it. \n\n ${RESET}"
fi

#Publish yoink to topic
Publish()
{
	local topicname="testtop"
	local key="testkey"
	local value="testval"
	local name="testname"

	echo -e "${GREEN}Topic to publish to:${RESET}"
	read topicname
	echo -e "${GREEN}Content Key:${RESET}"
	read key
	echo -e "${GREEN}Content Value:${RESET}"
        read value
	echo -e "${GREEN}Content UID/Name:${RESET}"
	read name
	echo -e "\n\033[7;34m$DWEET_SERVER/publish/yoink/for/$topicname?$key=$value&UID=$name${RESET}\n"
	curl "$DWEET_SERVER/publish/yoink/for/$topicname?$key=$value&UID=$name" | jq .
}

#Get Latest yoink from topic
GetLatest()
{
	local topicname="testtop"
	echo -e "${BLUE} What is the topic name?:${RESET}"
	read topicname
	curl "$DWEET_SERVER/get/latest/yoink/from/$topicname" |jq .
}

#Get last x yoinks from 
GetLastNum()
{
	local topicname="testtop"
	local yoinkcount="8"
	echo -e "${YELLOW} What is the topic name?:${RESET}"
	read topicname
	echo -e "${YELLOW} How many to retrieve?:${RESET}"
	read yoinkcount 
	curl "$DWEET_SERVER/get/latest/$yoinkcount/yoinks/from/$topicname" |jq .
}

#Get all yoinks from topic
GetMax()
{
	local topicname="testtop"
	echo -e "${CYAN} What is the topic name?:${RESET}"
	read topicname
	curl "$DWEET_SERVER/get/all/yoinks/from/$topicname" | jq .
}

ChangeServer()
{
	local newserve="new"
	echo -e "${RED}Enter the full address of the dweet server, this change is not persistent${RESET}"
	read newserve
	DWEET_SERVER=$newserve
	echo "$DWEET_SERVER"
}

Menu()
{
	echo -e "\n Please Choose an option"
	echo -e "${GREEN}   1) Publish a dweet"
	echo -e "${BLUE}   2) Get Latest dweet from a topic"
	echo -e "${YELLOW}   3) Get Latest [n] dweets from a topic"
	echo -e "${CYAN}   4) Get All Available dweets from a topic"
	echo -e "${RED}   5) Connect to a different Dweet server${RESET}"
	echo -e "Or press e or ctrl-c to exit\n"
}

Buhbye()
{
	echo -e "${CYAN} Thanks for playing!\n"
	exit 1
}


# Welcome message
echo -e "${CYAN}Welcome to the Interactive Dweet.me Shell!${RESET}"
echo -e "${CYAN}Going to connect to ${YELLOW} $DWEET_SERVER${RESET}" 

# Start the loop
while true; do
	
	#Run the menu options
	Menu 
	
	read -p "Pick a card any card: " menu_choice

    	case $menu_choice in
		1)
		    Publish 
		    ;;
		2)  
		    GetLatest
		    ;;
		3)
		    GetLastNum
		    ;;
		4)
		    GetMax
		    ;;
		5)
		    ChangeServer
		    ;;
		e)
		    Buhbye
		    ;;
	esac 

done


