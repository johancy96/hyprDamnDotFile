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

# Directorios a ignorar (no son configuraciones)
EXCLUDE_DIRS=(".git" ".github" "scripts" "assets")

# 1. Determinar origen de los archivos (Local vs Remoto)
if [ -f "./install.sh" ] && [ -d "./.git" ]; then
    printf "${BLUE}🏠 Ejecutando desde el repositorio local...${NC}\n"
    SOURCE_DIR="."
    IS_LOCAL=true
else
    REPO_URL="https://github.com/johancy96/hyprDamnDotFile.git"
    SOURCE_DIR="/tmp/hyprDamnDotFile"
    IS_LOCAL=false

    # Comprobar si git está instalado
    if ! command -v git &> /dev/null; then
        printf "${RED}❌ Error: git no está instalado. Por favor, instálalo antes de continuar.${NC}\n"
        exit 1
    fi

    if [ -d "$SOURCE_DIR" ]; then
        printf "${YELLOW}📂 Limpiando instalación temporal previa...${NC}\n"
        rm -rf "$SOURCE_DIR"
    fi

    printf "${BLUE}📥 Clonando repositorio en $SOURCE_DIR...${NC}\n"
    git clone --depth 1 "$REPO_URL" "$SOURCE_DIR"
fi

# 2. Detección dinámica de directorios de configuración
printf "${BLUE}🔍 Buscando configuraciones disponibles...${NC}\n"
CONFIG_DIRS=()
for d in "$SOURCE_DIR"/*/; do
    dir_name=$(basename "$d")
    # Comprobar si el directorio no está en la lista de exclusión
    [[ " ${EXCLUDE_DIRS[@]} " =~ " ${dir_name} " ]] && continue
    CONFIG_DIRS+=("$dir_name")
done

printf "${GREEN}✅ Encontradas: ${CONFIG_DIRS[*]}${NC}\n"

# 3. Instalación de directorios
mkdir -p "$HOME/.config"

for dir in "${CONFIG_DIRS[@]}"; do
    TARGET="$HOME/.config/$dir"
    SOURCE="$SOURCE_DIR/$dir"
    
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

# 4. Integración con la Shell (Fastfetch)
if [ -d "$HOME/.config/fastfetch" ]; then
    printf "${BLUE}🐚 Configurando Fastfetch en tu shell activa...${NC}\n"
    FETCH_CMD="~/.config/fastfetch/fetch.sh"
    chmod +x "$HOME/.config/fastfetch/fetch.sh" 2>/dev/null || true

    CURRENT_SHELL=$(basename "$SHELL")

    if [ "$CURRENT_SHELL" == "bash" ] && [ -f "$HOME/.bashrc" ]; then
        if ! grep -q "$FETCH_CMD" "$HOME/.bashrc"; then
            echo -e "\n# Fastfetch custom script\n$FETCH_CMD" >> "$HOME/.bashrc"
            printf "${GREEN}✅ Agregado a .bashrc (Shell activa: $CURRENT_SHELL)${NC}\n"
        fi
    elif [ "$CURRENT_SHELL" == "zsh" ] && [ -f "$HOME/.zshrc" ]; then
        if ! grep -q "$FETCH_CMD" "$HOME/.zshrc"; then
            echo -e "\n# Fastfetch custom script\n$FETCH_CMD" >> "$HOME/.zshrc"
            printf "${GREEN}✅ Agregado a .zshrc (Shell activa: $CURRENT_SHELL)${NC}\n"
        fi
    elif [ "$CURRENT_SHELL" == "fish" ]; then
        FISH_CONFIG="$HOME/.config/fish/config.fish"
        mkdir -p "$(dirname "$FISH_CONFIG")"
        if [ ! -f "$FISH_CONFIG" ] || ! grep -q "$FETCH_CMD" "$FISH_CONFIG"; then
            echo -e "\n# Fastfetch custom script\n$FETCH_CMD" >> "$FISH_CONFIG"
            printf "${GREEN}✅ Agregado a config.fish (Shell activa: $CURRENT_SHELL)${NC}\n"
        fi
    else
        printf "${YELLOW}⚠️  Shell detectada ($CURRENT_SHELL) no compatible o archivo de configuración ausente.${NC}\n"
        printf "${YELLOW}Por favor, agrega manualmente '$FETCH_CMD' a tu configuración de shell.${NC}\n"
    fi
fi

# 5. Limpieza
if [ "$IS_LOCAL" = false ]; then
    printf "${BLUE}🧹 Limpiando archivos temporales...${NC}\n"
    rm -rf "$SOURCE_DIR"
fi

printf "\n${GREEN}✨ Instalación completada con éxito!${NC}\n"
printf "${YELLOW}Nota: Recuerda que debes instalar manualmente las dependencias listadas en el README.md.${NC}\n"
printf "${BLUE}Disfruta de tu nuevo entorno de Hyprland! 🔥${NC}\n"
