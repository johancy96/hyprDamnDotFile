#!/bin/bash

if pgrep -x "hyprsunset" > /dev/null; then
    # Luz nocturna activa
    echo '{"text": "󰖔", "alt": "night", "class": "night", "tooltip": "Modo Nocturno Activo (4200K)"}'
else
    # Luz normal activa
    echo '{"text": "󰖙", "alt": "day", "class": "day", "tooltip": "Modo Diurno Activo"}'
fi
