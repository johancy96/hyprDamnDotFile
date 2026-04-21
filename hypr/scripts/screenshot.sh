#!/bin/bash

# Carpeta de capturas
DIR=~/Pictures/Screenshots
mkdir -p "$DIR"

# Nombre del archivo con fecha
NAME="screenshot_$(date +%Y%m%d_%H%M%S).png"
FILE="$DIR/$NAME"

# Modo: 'area' o 'full'
MODE=$1

if [ "$MODE" == "area" ]; then
    # 1. Obtener el área. Si slurp falla (Esc), salimos del script.
    AREA=$(slurp) || exit 0
    
    # 2. Capturar y pasar a swappy. 
    # Solo guardamos el archivo si swappy devuelve datos.
    grim -g "$AREA" - | swappy -f - -o - > "$FILE"
else
    # Captura de pantalla completa
    grim - | swappy -f - -o - > "$FILE"
fi

# 3. Verificación final: Si el archivo no existe o está vacío (usuario canceló en swappy)
if [ ! -s "$FILE" ]; then
    rm -f "$FILE"
    exit 0
fi

# 4. Éxito: Copiar al portapapeles y notificar
wl-copy < "$FILE"
notify-send "Captura Guardada" "La imagen se ha guardado y copiado al portapapeles." -i "$FILE" -a "Screenshot"
