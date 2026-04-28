#!/usr/bin/env bash

# 🔥 hyprDamnDotFile - Instalador de Configuraciones
# Este script instala los archivos de configuración en ~/.config/

set -e

# Colores para la terminal
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # Sin color

printf "${BLUE}🚀 Iniciando la instalación de hyprDamnDotFile...${NC}\n"

# Directorios a instalar
CONFIG_DIRS=("btop" "fastfetch" "hypr" "kitty" "matugen" "waybar" "waypaper" "wofi")
REPO_URL="https://github.com/johancy96/hyprDamnDotFile.git"
TEMP_DIR="/tmp/hyprDamnDotFile"

# 1. Comprobar si git está instalado
if ! command -v git &> /dev/null; then
    printf "${RED}❌ Error: git no está instalado. Por favor, instálalo antes de continuar.${NC}\n"
    exit 1
fi

# 2. Clonar el repositorio
if [ -d "$TEMP_DIR" ]; then
    printf "${YELLOW}📂 Limpiando instalación temporal previa...${NC}\n"
    rm -rf "$TEMP_DIR"
fi

printf "${BLUE}📥 Clonando repositorio en $TEMP_DIR...${NC}\n"
git clone --depth 1 "$REPO_URL" "$TEMP_DIR"

# 3. Instalación de directorios
mkdir -p "$HOME/.config"

for dir in "${CONFIG_DIRS[@]}"; do
    TARGET="$HOME/.config/$dir"
    SOURCE="$TEMP_DIR/$dir"
    
    if [ -d "$SOURCE" ]; then
        if [ -d "$TARGET" ]; then
            printf "${YELLOW}⚠️  Respaldando configuración existente de $dir...${NC}\n"
            mv "$TARGET" "${TARGET}_backup_$(date +%Y%m%d_%H%M%S)"
        fi
        
        printf "${GREEN}✅ Instalando $dir...${NC}\n"
        cp -r "$SOURCE" "$TARGET"
    else
        printf "${RED}❓ Advertencia: El directorio $dir no se encontró en el repositorio.${NC}\n"
    fi
done

# 4. Limpieza
printf "${BLUE}🧹 Limpiando archivos temporales...${NC}\n"
rm -rf "$TEMP_DIR"

printf "\n${GREEN}✨ Instalación completada con éxito!${NC}\n"
printf "${YELLOW}Nota: Recuerda que debes instalar manualmente las dependencias listadas en el README.md.${NC}\n"
printf "${BLUE}Disfruta de tu nuevo entorno de Hyprland! 🔥${NC}\n"
