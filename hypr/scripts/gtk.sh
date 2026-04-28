#!/bin/bash

# Este script sincroniza las configuraciones de gsettings con los archivos settings.ini de GTK
# para asegurar que los temas, iconos y fuentes se apliquen dinámicamente.

CONFIG_3="$HOME/.config/gtk-3.0/settings.ini"
CONFIG_4="$HOME/.config/gtk-4.0/settings.ini"

# Priorizar GTK3 como fuente de verdad, si no existe probar GTK4
if [ -f "$CONFIG_3" ]; then
    CONFIG="$CONFIG_3"
elif [ -f "$CONFIG_4" ]; then
    CONFIG="$CONFIG_4"
else
    echo "No se encontró configuración de GTK."
    exit 1
fi

# Función para extraer valores de settings.ini sin depender de espacios
get_setting() {
    grep "$1" "$CONFIG" | cut -d'=' -f2 | xargs
}

# Extraer valores
GTK_THEME=$(get_setting "gtk-theme-name")
ICON_THEME=$(get_setting "gtk-icon-theme-name")
CURSOR_THEME=$(get_setting "gtk-cursor-theme-name")
CURSOR_SIZE=$(get_setting "gtk-cursor-theme-size")
FONT_NAME=$(get_setting "gtk-font-name")
PREFER_DARK=$(get_setting "gtk-application-prefer-dark-theme")

# Esquema de GNOME para gsettings
gnome_schema="org.gnome.desktop.interface"

# Aplicar configuraciones si se encontraron
[ ! -z "$GTK_THEME" ] && gsettings set $gnome_schema gtk-theme "$GTK_THEME"
[ ! -z "$ICON_THEME" ] && gsettings set $gnome_schema icon-theme "$ICON_THEME"
[ ! -z "$CURSOR_THEME" ] && gsettings set $gnome_schema cursor-theme "$CURSOR_THEME"
[ ! -z "$FONT_NAME" ] && gsettings set $gnome_schema font-name "$FONT_NAME"

# Sincronizar el esquema de color oscuro
if [ "$PREFER_DARK" == "1" ]; then
    gsettings set $gnome_schema color-scheme 'prefer-dark'
else
    gsettings set $gnome_schema color-scheme 'default'
fi

# Importante para que GTK4 y libadwaita respeten el tema oscuro
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Reiniciar portales para asegurar que detecten los cambios
sleep 1
killall -e xdg-desktop-portal-hyprland
killall -e xdg-desktop-portal-gtk
killall -e xdg-desktop-portal
/usr/lib/xdg-desktop-portal-hyprland &
sleep 2
/usr/lib/xdg-desktop-portal &
