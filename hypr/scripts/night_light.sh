#!/bin/bash

# Configuración
TEMP=4200
START_HOUR=18  # 6 PM
END_HOUR=6     # 6 AM
LOG=~/.config/hypr/scripts/night_light.log

echo "--- Iniciando Night Light Script: $(date) ---" > $LOG

while true; do
    # Usamos %-H para evitar problemas de ceros iniciales (octal)
    CURRENT_HOUR=$(date +%-H)
    
    # Comprobar si estamos en el rango nocturno
    if [ "$CURRENT_HOUR" -ge "$START_HOUR" ] || [ "$CURRENT_HOUR" -lt "$END_HOUR" ]; then
        # Es de noche
        if ! pgrep -x "hyprsunset" > /dev/null; then
            echo "$(date): Es de noche. Iniciando hyprsunset..." >> $LOG
            hyprsunset -t $TEMP & >> $LOG 2>&1
        fi
    else
        # Es de día
        if pgrep -x "hyprsunset" > /dev/null; then
            echo "$(date): Es de día. Deteniendo hyprsunset..." >> $LOG
            pkill hyprsunset
        fi
    fi
    
    sleep 60
done
