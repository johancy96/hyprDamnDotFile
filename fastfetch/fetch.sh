#!/bin/bash

# Rutas
ICON_DIR="/mnt/Respaldos/iconos terminal"
CACHE_FILE=~/.config/fastfetch/image_cache.txt

# Función para actualizar la caché
update_cache() {
    find "$ICON_DIR" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.svg" -o -name "*.webp" \) > "$CACHE_FILE" 2>/dev/null
}

# 1. Crear caché si no existe o tiene más de 24 horas
if [ ! -f "$CACHE_FILE" ] || [ $(find "$CACHE_FILE" -mmin +1440) ]; then
    update_cache
fi

# 2. Intentar elegir una imagen válida
if [ -s "$CACHE_FILE" ]; then
    RANDOM_ICON=$(shuf -n 1 "$CACHE_FILE")

    # Si la imagen elegida NO existe (porque fue borrada del HDD)
    if [ ! -f "$RANDOM_ICON" ]; then
        # Forzar actualización de la caché inmediatamente
        update_cache
        # Reintentar elegir una nueva
        RANDOM_ICON=$(shuf -n 1 "$CACHE_FILE")
    fi

    # Ejecutar fastfetch
    if [ -f "$RANDOM_ICON" ]; then
        fastfetch --logo "$RANDOM_ICON"
    else
        fastfetch
    fi
else
    fastfetch
fi
