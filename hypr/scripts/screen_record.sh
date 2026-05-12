#!/bin/bash

# Directorio de grabaciones
SAVE_DIR="$HOME/Videos/Recordings"
mkdir -p "$SAVE_DIR"

# Nombre del archivo basado en la fecha
FILENAME="recording_$(date +%Y-%m-%d_%H-%M-%S).mp4"
FILEPATH="$SAVE_DIR/$FILENAME"

# Verificar si gpu-screen-recorder ya está corriendo
# El nombre del proceso suele cortarse a "gpu-screen-reco" en pgrep
if pgrep -x "gpu-screen-reco" > /dev/null; then
    # Detener la grabación de forma segura enviando SIGINT
    pkill -INT gpu-screen-reco
    notify-send "Grabación" "Grabación finalizada y guardada en $SAVE_DIR" -i video-display -a "Sistema"
else
    # Seleccionar área con slurp
    GEOM=$(slurp)
    
    # Si el usuario cancela slurp, salimos
    if [ -z "$GEOM" ]; then
        exit 1
    fi

    # Convertir formato de slurp (X,Y WxH) a gpu-screen-recorder (WxH+X+Y)
    # Ejemplo slurp: 100,200 300x400 -> GSR: 300x400+100+200
    GSR_GEOM=$(echo $GEOM | sed 's/\([0-9]\+\),\([0-9]\+\) \([0-9]\+x[0-9]\+\)/\3+\1+\2/')

    # Iniciar grabación en segundo plano
    # -w region: indica que usaremos un área específica
    # -q ultra: calidad alta (usa menos CPU/GPU que presets de menor calidad)
    # -f 60: 60 FPS
    # -a default_output: graba el audio de lo que escuchas
    gpu-screen-recorder -w region -region "$GSR_GEOM" -f 60 -q ultra -a default_output -o "$FILEPATH" &
    
    notify-send "Grabación" "Iniciando grabación de área..." -i video-display -a "Sistema"
fi
