#!/bin/bash

BASEDIR=$(dirname $0)
linux() {
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
}
