#!/bin/bash

# Ruta completa del script para evitar problemas de resolución
SCRIPT_PATH="$HOME/.config/hypr/scripts/clipboard.sh"
TMP_FILE="/tmp/clipboard_initialized"

# Función para enviar notificaciones
notify_copy() {
    local type=$1
    
    # Si el archivo no existe, significa que es el primer evento (inicio de sesión)
    if [ ! -f "$TMP_FILE" ]; then
        touch "$TMP_FILE"
        return
    fi
    
    if [ "$type" == "text" ]; then
        notify-send "Fuego en el Portapapeles" "Texto capturado y guardado" -i edit-copy -a "Sistema" -t 2000
    else
        notify-send "Fuego en el Portapapeles" "Imagen capturada y guardada" -i image-x-generic -a "Sistema" -t 2000
    fi
}

# Ejecutar wl-paste en modo escucha
case $1 in
    text)
        # Limpiar el archivo de inicialización solo al arrancar el modo escucha
        rm -f "$TMP_FILE"
        wl-paste --type text --watch bash -c "cliphist store && $SCRIPT_PATH notify text"
        ;;
    image)
        wl-paste --type image --watch bash -c "cliphist store && $SCRIPT_PATH notify image"
        ;;
    notify)
        notify_copy $2
        ;;
esac
