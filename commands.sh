#!/bin/bash

#functions
stream() {
        command=$1
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "${command}"
}

