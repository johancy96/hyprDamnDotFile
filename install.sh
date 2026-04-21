#!/bin/bash

# 🎨 hyprDamnDotFile - Smart Installation Wizard
# Autor: Johancy
# Descripción: Instalador inteligente de dependencias y configuraciones para Arch, Fedora y Debian.

# --- Configuración de Colores ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# --- Variables Globales ---
FAILED_PACKAGES=()
OS=""
PKG_MANAGER=""
REPO_URL="https://github.com/johancy96/hyprDamnDotFile.git"

# --- Comprobar si el script se ejecuta de forma remota ---
if [ ! -d "hypr" ] || [ ! -d "waybar" ]; then
    echo -e "${YELLOW}󰇚 Ejecución remota detectada o archivos no encontrados.${NC}"
    echo -e "${BLUE}Clonando el repositorio en /tmp/hyprDamnDotFile...${NC}"
    rm -rf /tmp/hyprDamnDotFile
    git clone "$REPO_URL" /tmp/hyprDamnDotFile
    cd /tmp/hyprDamnDotFile || exit 1
fi

# --- Funciones de Utilidad ---
show_header() {
    clear
    echo -e "${MAGENTA}${BOLD}"
    echo "  🔥 hyprDamnDotFile - Smart Installer"
    echo "  ------------------------------------"
    echo -e "${NC}"
}

ask_yes_no() {
    local prompt="$1"
    read -p "$(echo -e "${CYAN}${prompt} (y/N): ${NC}")" response
    case "$response" in
        [yY][eE][sS]|[yY]) return 0 ;;
        *) return 1 ;;
    esac
}

# --- Detección de Sistema Operativo ---
detect_os() {
    show_header
    echo -e "${BOLD}Selecciona tu sistema operativo:${NC}"
    echo "1) Arch Linux"
    echo "2) Fedora"
    echo "3) Debian"
    read -p "Opción (1-3): " os_choice

    case $os_choice in
        1) OS="arch"; PKG_MANAGER="pacman" ;;
        2) OS="fedora"; PKG_MANAGER="dnf" ;;
        3) OS="debian"; PKG_MANAGER="apt" ;;
        *) echo -e "${RED}Opción inválida.${NC}"; exit 1 ;;
    esac
}

# --- Preparación de Repositorios ---
prepare_repos() {
    case $OS in
        arch)
            if ! command -v yay &> /dev/null && ! command -v paru &> /dev/null; then
                echo -e "${YELLOW}Aviso: No se detectó un AUR helper (yay/paru). Algunos paquetes podrían fallar.${NC}"
            fi
            ;;
        fedora)
            echo -e "${BLUE}Configurando repositorios COPR necesarios...${NC}"
            sudo dnf copr enable -y solopasha/hyprland
            sudo dnf copr enable -y heus-sueh/packages
            sudo dnf copr enable -y aquacash5/nerd-fonts
            ;;
        debian)
            echo -e "${BLUE}Actualizando índices de paquetes...${NC}"
            sudo apt update
            ;;
    esac
}

# --- Lógica de Instalación de Paquetes ---
install_packages() {
    local group_name="$1"
    shift
    local packages=("$@")

    if ask_yes_no "📦 ¿Instalar grupo: $group_name?"; then
        echo -e "${BLUE}Instalando paquetes de $group_name...${NC}"
        for pkg in "${packages[@]}"; do
            echo -e "${YELLOW}➜ Instalando: $pkg${NC}"
            case $OS in
                arch)
                    if pacman -Si "$pkg" &> /dev/null; then
                        sudo pacman -S --noconfirm --needed "$pkg"
                    elif command -v yay &> /dev/null; then
                        yay -S --noconfirm --needed "$pkg"
                    elif command -v paru &> /dev/null; then
                        paru -S --noconfirm --needed "$pkg"
                    else
                        FAILED_PACKAGES+=("$pkg ($group_name)")
                    fi
                    ;;
                fedora)
                    if sudo dnf install -y "$pkg"; then
                        :
                    else
                        FAILED_PACKAGES+=("$pkg ($group_name)")
                    fi
                    ;;
                debian)
                    if sudo apt install -y "$pkg"; then
                        :
                    else
                        # Intentar nombres alternativos o marcar como fallido
                        FAILED_PACKAGES+=("$pkg ($group_name)")
                    fi
                    ;;
            esac
        done
    else
        echo -e "${YELLOW}Saltando grupo $group_name.${NC}"
    fi
}

# --- Listas de Paquetes ---
# Arch
arch_screen=("nwg-displays" "grim" "slurp" "swappy" "wf-recorder")
arch_theming=("matugen-bin" "nwg-look" "qt5ct" "qt6ct" "qt5-styleplugins" "adw-gtk3-theme" "papirus-icon-theme" "waypaper" "swww" "hyprsunset")
arch_system=("waybar" "wofi" "dunst" "pavucontrol" "power-profiles-daemon")
arch_utils=("kitty" "fastfetch" "cliphist" "nwg-clipman" "wl-clipboard")
arch_fonts=("ttf-jetbrains-mono-nerd" "ttf-font-awesome")

# Fedora
fedora_screen=("nwg-displays" "grim" "slurp" "swappy" "wf-recorder")
fedora_theming=("matugen" "nwg-look" "qt5ct" "qt6ct" "qt5-styleplugins" "adw-gtk3-theme" "papirus-icon-theme" "waypaper" "swww" "hyprsunset")
fedora_system=("waybar" "wofi" "dunst" "pavucontrol" "power-profiles-daemon")
fedora_utils=("kitty" "fastfetch" "cliphist" "nwg-clipman" "wl-clipboard")
fedora_fonts=("jetbrains-mono-nerd-fonts" "fontawesome-fonts-all")

# Debian (Aproximación, algunos podrían requerir compilación)
debian_screen=("nwg-displays" "grim" "slurp" "swappy" "wf-recorder")
debian_theming=("nwg-look" "qt5ct" "qt6ct" "qt5-styleplugins" "adw-gtk3-theme" "papirus-icon-theme" "waypaper" "swww")
debian_system=("waybar" "wofi" "dunst" "pavucontrol" "power-profiles-daemon")
debian_utils=("kitty" "fastfetch" "cliphist" "wl-clipboard")
debian_fonts=("fonts-jetbrains-mono" "fonts-font-awesome")

# --- Flujo Principal ---
detect_os
prepare_repos

case $OS in
    arch)
        install_packages "Pantalla y Captura" "${arch_screen[@]}"
        install_packages "Estética y Tematización" "${arch_theming[@]}"
        install_packages "Componentes del Sistema" "${arch_system[@]}"
        install_packages "Utilidades y Portapapeles" "${arch_utils[@]}"
        install_packages "Fuentes" "${arch_fonts[@]}"
        ;;
    fedora)
        install_packages "Pantalla y Captura" "${fedora_screen[@]}"
        install_packages "Estética y Tematización" "${fedora_theming[@]}"
        install_packages "Componentes del Sistema" "${fedora_system[@]}"
        install_packages "Utilidades y Portapapeles" "${fedora_utils[@]}"
        install_packages "Fuentes" "${fedora_fonts[@]}"
        ;;
    debian)
        install_packages "Pantalla y Captura" "${debian_screen[@]}"
        install_packages "Estética y Tematización" "${debian_theming[@]}"
        install_packages "Componentes del Sistema" "${debian_system[@]}"
        install_packages "Utilidades y Portapapeles" "${debian_utils[@]}"
        install_packages "Fuentes" "${debian_fonts[@]}"
        ;;
esac

# --- Instalación de Carpetas de Configuración ---
echo -e "\n${BLUE}󰇚 Iniciando instalación de archivos de configuración...${NC}"
CONFIG_DIR="$HOME/.config"
folders=$(find . -maxdepth 1 -type d -not -path '*/.*' -not -path '.')

for folder_path in $folders; do
    folder_name=${folder_path#./}
    target="$CONFIG_DIR/$folder_name"

    if [ -d "$target" ]; then
        timestamp=$(date +%Y%m%d_%H%M%S)
        mv "$target" "${target}_backup_$timestamp"
    fi
    cp -r "$folder_path" "$CONFIG_DIR/"
    echo -e "${GREEN}󰄬 Instalado: $folder_name${NC}"
done

# --- Reporte Final ---
show_header
if [ ${#FAILED_PACKAGES[@]} -eq 0 ]; then
    echo -e "${GREEN}${BOLD}✨ ¡Instalación completada con éxito!${NC}"
else
    echo -e "${YELLOW}${BOLD}⚠️  Instalación finalizada con advertencias.${NC}"
    echo -e "Los siguientes paquetes no se pudieron instalar automáticamente:"
    for failed in "${FAILED_PACKAGES[@]}"; do
        echo -e "  - ${RED}$failed${NC}"
    done
    echo -e "\n${CYAN}Sugerencia: Intenta instalarlos manualmente o verifica tus repositorios.${NC}"
fi

echo -e "\n${BLUE}󰑓  Reinicia Hyprland (Super + M) para aplicar todos los cambios.${NC}\n"
chmod +x "$0"
