#!/bin/bash

# $1 is the wallpaper path provided by waypaper
WALLPAPER="$1"

# Limpiar espacios
WALLPAPER=$(echo "$WALLPAPER" | xargs)

if [ -z "$WALLPAPER" ] || [ ! -f "$WALLPAPER" ]; then
    WALLPAPER=$(grep '^wallpaper =' ~/.config/waypaper/config.ini | cut -d'=' -f2- | xargs)
fi

# 1. Ejecutar Matugen
if [ -f "$WALLPAPER" ]; then
    matugen -m dark -t scheme-fidelity image "$WALLPAPER"
fi

# 2. Ejecutar el refresco global
~/.config/matugen/scripts/refresh.sh
