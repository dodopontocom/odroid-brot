#!/bin/bash

#functions
stream() {
	command=$1
	array=(${command})
	array[0]="/stream"
	command=${array[@]:1}
	echo "${command}"
	if [[ "${command}" -eq "on" ]]; then
		motion
		sleep 3
		ngrok http -log stdout 8081 > logs/ngrok-${message_date}.log &
		sleep 3
		
		ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "Live Stream at\n \
				$(tail -1 logs/ngrok-${message_date}.log | cut -d'=' -f8)"
	
	elif [[ "${command}" -eq "off" ]]; then
		ngrok_pid=$(ps -ef | grep -E "8081|ngrok" | grep -v grep | awk '{print $2}')
		motion_pid=$(ps -ef | grep "motion" | grep -v grep | awk '{print $2}')
		kill -9 ${motion_pid}
		kill -9 ${ngrok_pid}
		sleep 3
			
		ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "Live Stream is now off"
	
	else
		ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "Usage: ${array[0]} <on> or <off>"
	
	fi
}

