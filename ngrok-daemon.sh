#!/bin/bash

BASEDIR=$(dirname $0)

timestamp=$(date "+%Y%m%d-%H%M%S")
log=${BASEDIR}/logs/ngrok-daemon-${timestamp}.log
cmd=$(ngrok http -region=eu -log stdout 9000 > ${log} &)
sleep 3
url=$(tail -1 ${log} | cut -d'=' -f8)
sendTelegram() {

	new_url=$1

	token=$(cat ${BASEDIR}/.token)
	myId=11504381
	groupId="-285482986"
	apiUrl=https://api.telegram.org/bot${token}/sendMessage

	messageText="Odroid Portainer - New url available\n"
	messageText+="${new_url}"
	#sendMessage
	curl -s -X POST $apiUrl -d chat_id=${groupId} -d text="$(echo -e ${messageText})"
	
}
sendTelegram "${url}"
