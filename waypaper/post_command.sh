#!/bin/bash

# $1 es la ruta del fondo de pantalla proporcionada por waypaper
WALLPAPER="$1"

# Log para depuración
LOG="$HOME/.config/matugen/refresh.log"
echo "--- Matugen Trigger: $(date) ---" >> "$LOG"
echo "Imagen recibida: $WALLPAPER" >> "$LOG"

# Si la ruta viene vacía o no existe, intentar leerla del config.ini de waypaper
if [ -z "$WALLPAPER" ] || [ ! -f "$WALLPAPER" ]; then
    # Limpiamos posibles escapes de barra invertida que añade Waypaper
    WALLPAPER=$(grep '^wallpaper =' ~/.config/waypaper/config.ini | cut -d'=' -f2- | xargs)
    echo "Ruta corregida de config.ini: $WALLPAPER" >> "$LOG"
fi

# 1. Ejecutar Matugen con --source-color-index 0 para evitar el error de múltiples colores
# en modo no interactivo.
if [ -f "$WALLPAPER" ]; then
    # Usamos --source-color-index 0 para que elija el color más dominante automáticamente
    matugen -m dark -t scheme-fidelity --source-color-index 0 image "$WALLPAPER" >> "$LOG" 2>&1
    
    if [ $? -eq 0 ]; then
        echo "Matugen ejecutado con éxito." >> "$LOG"
    else
        echo "ERROR: Matugen falló. Revisa el log arriba." >> "$LOG"
    fi
else
    echo "ERROR: La imagen no existe o la ruta es inválida: $WALLPAPER" >> "$LOG"
fi

# 2. Ejecutar el refresco global explícitamente para asegurar que se apliquen los cambios
# incluso si matugen tiene su propio post_command.
~/.config/matugen/scripts/refresh.sh >> "$LOG" 2>&1
