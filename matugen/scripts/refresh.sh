#!/bin/bash

# Log de salida para depuración
LOG="$HOME/.config/matugen/refresh.log"
echo "--- Refresco Global: $(date) ---" > $LOG

# Recargar configuración de Hyprland
hyprctl reload >> $LOG 2>&1

# Reiniciar Waybar de forma limpia
pkill waybar
waybar & >> $LOG 2>&1

# Reiniciar Dunst usando systemd si está disponible, si no, usar pkill
if systemctl --user is-active --quiet dunst; then
    systemctl --user restart dunst >> $LOG 2>&1
else
    pkill dunst
    dunst & >> $LOG 2>&1
fi

# Recargar Kitty (enviar señal SIGUSR1 a todas las instancias)
pkill -USR1 kitty >> $LOG 2>&1

# --- Gestión de btop y su Terminal Kitty ---
# Buscamos todos los PIDs de btop
for BTOP_PID in $(pgrep -x "btop"); do
    echo "Procesando btop PID: $BTOP_PID" >> $LOG
    
    # Buscamos al ancestro Kitty (subiendo hasta 5 niveles en el árbol)
    CURRENT_PID=$BTOP_PID
    TERMINAL_PID=""
    
    for i in {1..5}; do
        # Obtener el padre del proceso actual
        PARENT_PID=$(ps -o ppid= -p "$CURRENT_PID" | tr -d ' ')
        [ -z "$PARENT_PID" ] || [ "$PARENT_PID" -eq 1 ] && break
        
        # Obtener el nombre del proceso padre
        PARENT_NAME=$(ps -o comm= -p "$PARENT_PID" | tr -d ' ')
        
        if [ "$PARENT_NAME" = "kitty" ]; then
            TERMINAL_PID=$PARENT_PID
            break
        fi
        CURRENT_PID=$PARENT_PID
    done
    
    if [ -n "$TERMINAL_PID" ]; then
        echo "Cerrando ancestro Kitty (PID: $TERMINAL_PID)..." >> $LOG
        kill "$TERMINAL_PID" >> $LOG 2>&1
    else
        echo "No se encontró ancestro Kitty. Matando btop directamente..." >> $LOG
        kill "$BTOP_PID" >> $LOG 2>&1
    fi
    
    # Marcar que necesitamos relanzar btop
    RELAUNCH_BTOP=true
done

# Si hubo algún btop cerrado, lanzamos uno nuevo con el tema actualizado
if [ "$RELAUNCH_BTOP" = true ]; then
    sleep 0.6
    kitty --title "btop-fire" -e btop & >> $LOG 2>&1
fi

echo "ok"
echo "Refresco completado." >> $LOG
