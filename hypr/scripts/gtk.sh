#!/bin/bash

# Define settings
gnome_schema="org.gnome.desktop.interface"

# Set GTK Theme, Icons and Fonts
gsettings set $gnome_schema gtk-theme 'Adwaita-dark'
gsettings set $gnome_schema icon-theme 'Adwaita'
gsettings set $gnome_schema cursor-theme 'Adwaita'
gsettings set $gnome_schema font-name 'JetBrainsMono Nerd Font 10'
gsettings set $gnome_schema color-scheme 'prefer-dark'

# This script ensures that GTK applications use the dark mode
# and follow the colors defined in our gtk.css overrides.
