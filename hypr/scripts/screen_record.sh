#!/bin/bash

# Directorio de grabaciones
SAVE_DIR="$HOME/Videos/Recordings"
mkdir -p "$SAVE_DIR"

# Nombre del archivo basado en la fecha
FILENAME="recording_$(date +%Y-%m-%d_%H-%M-%S).mp4"
FILEPATH="$SAVE_DIR/$FILENAME"

# Verificar si wf-recorder ya está corriendo
if pgrep -x "wf-recorder" > /dev/null; then
    # Detener la grabación
    pkill -INT wf-recorder
    notify-send "Grabación" "Grabación finalizada y guardada en $SAVE_DIR" -i video-display
else
    # Seleccionar área con slurp
    GEOM=$(slurp)
    
    # Si el usuario cancela slurp, salimos
    if [ -z "$GEOM" ]; then
        exit 1
    fi

    # Iniciar grabación en segundo plano
    wf-recorder -g "$GEOM" -f "$FILEPATH" &
    
    notify-send "Grabación" "Iniciando grabación de pantalla..." -i video-display
fi
