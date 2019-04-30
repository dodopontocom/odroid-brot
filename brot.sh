#!/bin/bash
#

#sleep para funcionar melhor no startup do sistema
sleep 10

# Importando API
BASEDIR=$(dirname $0)
echo ${BASEDIR}
source ${BASEDIR}/ShellBot.sh

logs=${BASEDIR}/logs

# Token do bot
bot_token=$(cat ${BASEDIR}/.token)

# Inicializando o bot
ShellBot.init --token "$bot_token" --monitor --flush

while :
do
	ShellBot.getUpdates --limit 100 --offset $(ShellBot.OffsetNext) --timeout 30
	
	for id in $(ShellBot.ListUpdates)
	do
	(
		if [[ ${message_entities_type[$id]} == bot_command ]]; then
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/linux" )" ]]; then
				command="${message_text[$id]}"
				array=(${command})
				array[0]="/linux"
				command=${array[@]:1}
				echo "${command}"
				if [[ ! -z ${command} ]]; then
					ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(${command})"
				else
					ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "Usage: ${array[0]} <command>"
				fi
					
			fi
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/expose" )" ]]; then
				timestamp=$(date "+%Y%m%d%H%M%S")
				command="${message_text[$id]}"
				array=(${command})
				array[0]="/expose"
				command=${array[@]:1}
				if [[ "${command}" -eq "22" ]]; then
					final_command=$(ngrok tcp -log stdout ${command} > logs/ngrok-${message_date}.log &)
				else
					final_command=$(ngrok http -log stdout ${command} > logs/ngrok-${message_date}.log &)
				fi
				echo "${command}"
				if [[ ! -z ${command} ]]; then
					${final_command}
					sleep 3
					ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "Use the command as follow\n \
						ssh $(tail -1 logs/ngrok-${message_date}.log | cut -d'/' -f5 | sed 's/:/ -p/')"
				else
					ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "Usage: ${array[0]} <port>"
				fi
					
			fi
		fi	
	) & 
	done
done
#FIM