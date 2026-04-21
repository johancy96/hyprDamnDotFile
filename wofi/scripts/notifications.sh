#!/bin/bash

# Función para obtener el estado de Dunst para Waybar
get_status() {
    if dunstctl is-paused &>/dev/null; then
        is_paused=$(dunstctl is-paused)
        if [ "$is_paused" == "true" ]; then
            echo '{"text": "󰂛", "class": "paused", "tooltip": "Modo No Molestar Activo"}'
        else
            echo '{"text": "󰂚", "class": "normal", "tooltip": "Notificaciones activas"}'
        fi
    else
        echo '{"text": "󰂚", "class": "disabled", "tooltip": "Dunst no responde"}'
    fi
}

# Función para mostrar el historial en Wofi con estilo propio
show_history() {
    # Definimos la opción de limpiar al principio
    clear_option="󰎟 Limpiar todo el historial"
    
    # Obtenemos el historial de Dunst
    history=$(dunstctl history 2>/dev/null | jq -r '.data[] | reverse | .[] | .summary.data + " | " + .body.data' 2>/dev/null)
    
    # Si no hay historial, solo mostramos el botón de limpiar o un aviso
    if [ -z "$history" ]; then
        selection=$(echo -e "No hay notificaciones recientes" | wofi --dmenu --hide-search --prompt "Historial" --conf ~/.config/wofi/config --style ~/.config/wofi/notifications.css --width 600 --height 300)
    else
        # Unimos la opción de limpiar con el historial
        selection=$(printf "%s\n%s" "$clear_option" "$history" | wofi --dmenu --hide-search --prompt "Notificaciones" --conf ~/.config/wofi/config --style ~/.config/wofi/notifications.css --width 800 --height 500)
    fi

    # Lógica basada en la selección (sin notificaciones de confirmación)
    if [ "$selection" == "$clear_option" ]; then
        dunstctl history-clear
        dunstctl close-all
    fi
}

case $1 in
    "list")
        show_history
        ;;
    "clear")
        dunstctl close-all && dunstctl history-clear
        ;;
    *)
        get_status
        ;;
esac
