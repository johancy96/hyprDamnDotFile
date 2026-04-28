#!/bin/bash

# Rutas usando $HOME para mayor compatibilidad
ICON_DIR="/mnt/Respaldos/iconos"
CONFIG_FILE="$HOME/.config/fastfetch/config.jsonc"
CACHE_FILE="$HOME/.config/fastfetch/image_cache.txt"

# Función para actualizar la caché
update_cache() {
    echo "Actualizando caché de imágenes..."
    find "$ICON_DIR" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.svg" -o -name "*.webp" \) > "$CACHE_FILE" 2>/dev/null
}

# 1. Crear caché si no existe o tiene más de 24 horas
# También forzamos actualización si el archivo está vacío o no contiene la ruta nueva
if [ ! -s "$CACHE_FILE" ] || [ $(find "$CACHE_FILE" -mmin +1440 2>/dev/null) ] || ! grep -q "$ICON_DIR" "$CACHE_FILE" 2>/dev/null; then
    update_cache
fi

# 2. Intentar elegir una imagen válida
if [ -s "$CACHE_FILE" ]; then
    RANDOM_ICON=$(shuf -n 1 "$CACHE_FILE")

    # Si la imagen elegida NO existe (por ejemplo, si se movieron archivos)
    if [ ! -f "$RANDOM_ICON" ]; then
        update_cache
        RANDOM_ICON=$(shuf -n 1 "$CACHE_FILE")
    fi

    # Ejecutar fastfetch
    if [ -f "$RANDOM_ICON" ]; then
        # Forzamos la configuración, el logo y el protocolo kitty con reporte de errores
        fastfetch --config "$CONFIG_FILE" --logo "$RANDOM_ICON" --logo-type kitty --show-errors
    else
        fastfetch --config "$CONFIG_FILE"
    fi
else
    # Si no hay imágenes, ejecutar solo con config
    fastfetch --config "$CONFIG_FILE"
fi
