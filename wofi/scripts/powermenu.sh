#!/bin/bash

# Powermenu Script using Wofi

template="$HOME/.config/wofi/powermenu_template"
selected=$(cat "$template" | wofi --dmenu --class wofi-powermenu --cache-file /dev/null --style "$HOME/.config/wofi/powermenu.css" --width 600 --height 480 --columns 2 --location center --hide-scroll --no-actions --hide-search --content_halign center --prompt "")

case $selected in
  "󰐥 Apagar")
    systemctl poweroff
    ;;
  "󰑓 Reiniciar")
    systemctl reboot
    ;;
  "󰤄 Suspender")
    systemctl suspend
    ;;
  "󰈆 Logout")
    # Generic logout for Wayland/Hyprland
    hyprctl dispatch exit || swaymsg exit || killall -u $USER
    ;;
esac
