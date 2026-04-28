# 🔥 hyprDamnDotFile

Un entorno de **Hyprland** dinámico, premium y altamente personalizado. Este proyecto utiliza **Matugen** para generar paletas de colores consistentes a partir del fondo de pantalla, logrando una estética visual cohesiva en todos los componentes del sistema.

## 📦 Dependencias

Para que este entorno funcione correctamente, asegúrate de tener instalados los siguientes paquetes:

### 🖥️ Pantalla y Captura
- `nwg-displays`: Configuración visual de monitores.
- `grim`: Utilidad para realizar capturas de pantalla.
- `slurp`: Selección de regiones en Wayland.
- `swappy`: Herramienta de edición para capturas de pantalla.
- `wf-recorder`: Grabador de pantalla para Wayland.

### 🎨 Estética y Tematización
- `matugen`: Generador de paletas de colores dinámicas (Material You).
- `nwg-look`: Instalador de temas GTK3.
- `qt5ct` & `qt6ct`: Configuración de temas para aplicaciones Qt.
- `qt5-styleplugins`: Plugins de estilo para Qt5.
- `adw-gtk3-theme`: Tema GTK compatible con Libadwaita.
- `papirus-icon-theme`: Pack de iconos premium.
- `waypaper`: Frontend para la gestión de fondos de pantalla.
- `hyprpaper`: Wallpaper daemon ligero y oficial de Hyprland.
- `hyprsunset`: Control de luz nocturna (filtro de luz azul).

### 🛠️ Componentes del Sistema
- `waybar`: Barra de estado altamente personalizable.
- `wofi`: Lanzador de aplicaciones y menús dinámicos.
- `dunst`: Demonio de notificaciones ligero.
- `libnotify`: Biblioteca y utilidades para enviar notificaciones (`notify-send`).
- `pavucontrol`: Control de volumen por software.
- `power-profiles-daemon`: Gestión de perfiles de energía (ahorro, balanceado, rendimiento).
- `xdg-desktop-portal-gtk`: Portal de escritorio para integración con aplicaciones GTK.

### ⌨️ Utilidades y Portapapeles
- `kitty`: Emulador de terminal rápido y basado en GPU.
- `fastfetch`: Información del sistema con estilo.
- `cliphist`: Historial del portapapeles.
- `nwg-clipman`: Gestor visual del portapapeles.
- `wl-clipboard`: Utilidades para el portapapeles en Wayland.
- `jq`: Procesador de JSON en línea de comandos (usado en scripts).
- `imagemagick`: Herramientas de manipulación de imágenes.

### 🔡 Fuentes (Obligatorias)
Para que los iconos y símbolos se vean correctamente, es necesario instalar las siguientes fuentes:

| Distribución | Nerd Fonts (JetBrainsMono) | Font Awesome |
| :--- | :--- | :--- |
| **Arch Linux** | `ttf-jetbrains-mono-nerd` | `ttf-font-awesome` |
| **Fedora** | `jetbrains-mono-nerd-fonts` (vía COPR*) | `fontawesome-fonts-all` |
| **Debian** | Manual (o `fonts-jetbrains-mono`) | `fonts-font-awesome` |

> [!NOTE]
> En **Fedora**, puedes habilitar las Nerd Fonts con: `sudo dnf copr enable aquacash5/nerd-fonts`. En **Debian**, se recomienda descargar la fuente desde [nerdfonts.com](https://www.nerdfonts.com/) e instalarla en `~/.local/share/fonts`.


## 🚀 Instalación

> [!IMPORTANT]
> **Este script de instalación solo copia los archivos de configuración (`dotfiles`)**. La gestión de paquetes y la instalación de las dependencias listadas anteriormente deben ser realizadas manualmente por el usuario según su distribución de Linux.

### Instalación Rápida (One-liner)

Puedes instalar todas las configuraciones con un solo comando dependiendo de tu shell:

**Bash / Zsh:**
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/johancy96/hyprDamnDotFile/main/install.sh)"
```

**Fish:**
```fish
curl -fsSL https://raw.githubusercontent.com/johancy96/hyprDamnDotFile/main/install.sh | bash
```

### Instalación Manual

Si prefieres hacerlo paso a paso:

1. **Clonar el repositorio:**
   ```bash
   git clone https://github.com/johancy96/hyprDamnDotFile.git
   ```

2. **Copiar las carpetas de configuración:**
   ```bash
   cd hyprDamnDotFile
   cp -r btop fastfetch hypr kitty matugen waybar waypaper wofi ~/.config/
   ```
3. **Integración con la Shell:**
   Para que los iconos aparezcan automáticamente al abrir la terminal, agrega la siguiente línea al final de tu archivo de configuración (`~/.bashrc`, `~/.zshrc` o `~/.config/fish/config.fish`):
   ```bash
   ~/.config/fastfetch/fetch.sh
   ```
   *No olvides darle permisos de ejecución:* `chmod +x ~/.config/fastfetch/fetch.sh`



## 🎨 Personalización

### Iconos de Fastfetch
Puedes personalizar la imagen que aparece al abrir la terminal agregando tus propios archivos (PNG, JPG, SVG, etc.) en la carpeta de configuración:
`~/.config/fastfetch/icons/`

El script `fetch.sh` elegirá automáticamente una imagen al azar de esa carpeta cada vez que abras la terminal o ejecutes el comando.


---
> [!TIP]
> Este proyecto está diseñado para ser visualmente impactante. Se recomienda usar fuentes modernas como **Inter** o **JetBrainsMono Nerd Font** para la mejor experiencia.
