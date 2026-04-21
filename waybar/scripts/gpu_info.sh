#!/bin/bash

# Script de información de GPU inteligente para AMD/NVIDIA
gpu_usage=0
gpu_temp=0

# 1. Intentar NVIDIA (nvidia-smi)
if command -v nvidia-smi &> /dev/null; then
    gpu_usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | head -n 1)
    gpu_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits | head -n 1)

# 2. Intentar AMD (Detección dinámica)
else
    # Buscar porcentaje de uso
    for card in /sys/class/drm/card*/device/gpu_busy_percent; do
        if [ -f "$card" ]; then
            gpu_usage=$(cat "$card")
            break
        fi
    done

    # Buscar temperatura (escaneando hwmon por 'amdgpu')
    for hw in /sys/class/hwmon/hwmon*/name; do
        if grep -q "amdgpu" "$hw" 2>/dev/null; then
            hw_dir=$(dirname "$hw")
            if [ -f "$hw_dir/temp1_input" ]; then
                gpu_temp=$(($(cat "$hw_dir/temp1_input") / 1000))
                break
            fi
        fi
    done
fi

# Fallback por si falla la detección
[[ -z "$gpu_usage" ]] && gpu_usage=0
[[ -z "$gpu_temp" ]] && gpu_temp=0

# Salida en formato JSON para Waybar (El icono se añade en config.jsonc)
echo "{\"text\": \"$gpu_usage% $gpu_temp°C\", \"tooltip\": \"GPU: AMD Radeon RX 6700 XT\nUso: $gpu_usage%\nTemp: $gpu_temp°C\"}"
