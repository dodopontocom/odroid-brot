#!/bin/bash

BASEDIR=$(dirname $0)

#functions
stream() {
	command=$1
	array=(${command})
	logs="${BASEDIR}/logs/ngrok-${message_date}.log"
	array[0]="/stream"
	command=${array[@]:1}
	echo "${command}"
	if [[ "${command}" == "on" ]]; then
		motion
		sleep 3
		ngrok http -log stdout 8081 > ${logs} &
		sleep 3
		
		ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "Live Stream at\n \
				$(tail -1 ${logs} | cut -d'=' -f8)"
	
	elif [[ "${command}" == "off" ]]; then
		ngrok_pid=$(ps -ef | grep -v grep | grep "ngrok http -log stdout 8081" | awk '{print $2}')
		motion_pid=$(ps -ef | grep "motion" | grep -v grep | awk '{print $2}')
		kill -9 ${motion_pid}
		kill -9 ${ngrok_pid}
		sleep 3
			
		ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "Live Stream is now off"
	
	elif [[ -z ${command} ]]; then
		ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "Usage: ${array[0]} <on> or <off>"
	
	fi
}

