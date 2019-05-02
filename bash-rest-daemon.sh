#!/bin/bash

BASEDIR=$(dirname $0)

timestamp=$(date "+%Y%m%d-%H%M%S")
log=${BASEDIR}/logs/bash-rest-daemon-${timestamp}.log
cmd=$(ngrok http -region=au -log stdout 8083 > ${log} &)
sleep 6
url=$(tail -1 ${log} | cut -d'=' -f8)
sendTelegram() {

	new_url=$1

	token=$(cat ${BASEDIR}/.token)
	myId=11504381
	groupId="-285482986"
	apiUrl=https://api.telegram.org/bot${token}/sendMessage

	messageText="Odroid bash-rest-API - New url available\n"
	messageText+="${new_url}"
	#sendMessage
	curl -s -X POST $apiUrl -d chat_id=${myId} -d text="$(echo -e ${messageText})"
	
}
sendTelegram "${url}"
