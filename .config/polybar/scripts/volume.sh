#!/bin/bash

# Obtém o volume atual e o status de mudo
volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '[0-9]+(?=%)')
mute=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

# Verifica se o comando retornou um valor válido
if [ -z "$volume" ]; then
    volume=0
fi

# Verifica o status de mudo e formata a saída
if [ "$mute" == "yes" ]; then
    echo " Muted"
else
    if [ "$volume" -le 33 ]; then
        icon=""
    elif [ "$volume" -le 66 ]; then
        icon=""
    else
        icon=""
    fi
    echo "$icon $volume%"
fi

