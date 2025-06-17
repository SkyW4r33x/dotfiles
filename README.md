![Banner](https://i.imgur.com/CS0EsS3.png)  
		**_Created by SkyW4r33x_**
		
# SkyW4r33x GNOME Setup

Este script automatiza la instalación y configuración de **SkyW4r33x**, un entorno personalizado basado en **GNOME** para sistemas derivados de **Debian**, como **Kali Linux**. Incluye extensiones, herramientas, configuraciones de terminal, dotfiles y personalizaciones visuales inspiradas en Kali Linux.

## ⚙️ Requisitos previos

-   **Sistema operativo**: Debian/Kali Linux
-   **Entorno gráfico**: GNOME Shell (versión 47 o superior recomendada)
-   **Privilegios**: Acceso a `sudo` para instalación y configuración del sistema
-   **Dependencias mínimas**:
    -   `git`, `make`, `gettext`, `gnome-shell`, `dconf-cli` (verificadas automáticamente)

## 🚀 Instalación

1.  **Actualiza el sistema** (recomendado antes de instalar):
    
    ```bash
    sudo apt update && sudo apt upgrade -y
    
    ```
    
2.  **Clona o descarga este repositorio**:
    
    ```bash
    git clone https://github.com/SkyW4r33x/dotfiles.git
    cd dotfiles
    
    ```
    
3.  **Otorga permisos al script de instalación**:
    
    ```bash
    chmod +x install.py
    
    ```
    
4.  **Ejecuta el instalador**:
    
    ```bash
    ./install.py
    
    ```
    
5.  **Sigue las instrucciones en pantalla**:
    
    -   Verificación de dependencias
    -   Instalación progresiva con interfaz tipo consola
    -   Reiniciar GNOME Shell (`Alt + F2` + `r` + Enter) o el sistema al finalizar

## 🌟 Novedades y Mejoras Recientes

### ✨ Actualizaciones Principales

-   ✅ **Neovim actualizado a la versión 0.11** con mejoras significativas:
    -   Configuración LSP simplificada y mejorada
    -   Autocompletado integrado nativo
    -   Mejor documentación hover
    -   Rendimiento mejorado de tree-sitter
    -   Soporte mejorado para emojis
    -   Mejoras en el emulador de terminal integrado

### 🎨 Mejoras Visuales

-   ✅ **Nuevo fondo de pantalla**
-   ✅ **Fondo personalizado para GDM (pantalla de bloqueo GNOME)**
-   ✅ **Fondo sincronizado para la página de inicio del navegador**
-   ✅ **Nuevo diseño mejorado para comandos del sistema**:
    -   `updateAndClean` con interfaz visual renovada
    -   `dockerClean` con nuevo estilo de presentación

### 🔌 Nuevas Extensiones

-   ✅ **Nuevas extensiones integradas**:
    -   `Local IP Info`
    -   `Target Info`
    -   `VPN IP`

## 📦 Características principales

### 🔌 Extensiones GNOME

-   **Dash to Panel**: Transforma el dock en una barra inferior unificada.
-   **Executor**: Ejecuta scripts dinámicos como `target.sh`, `vpnip.sh` y `ethernet.sh`.
-   **Extras**:
    -   `Local IP Info`: Muestra la IP local y permite copiarla al portapapeles con un clic.
    -   `Target Info`: Muestra información del objetivo y permite copiar la IP al portapapeles con un clic.
    -   `VPN IP`: Muestra la IP de la VPN y permite copiarla al portapapeles con un clic. 
    ![test](https://i.imgur.com/tlpk7q9.gif)


### 🧰 Herramientas Incluidas

| Herramienta  | Descripción                          |
|--------------|--------------------------------------|
| `zsh`        | Shell avanzada con `.zshrc` personalizado |
| `neovim`     | Con configuración NvChad             |
| `fzf`        | Búsqueda fuzzy                       |
| `lsd` / `bat`| Sustitutos visuales de `ls` y `cat`  |
| `terminator` | Terminal en mosaico configurable     |
| `kitty` incompleto      | Terminal ligero con transparencia y tabs |
| `flameshot`  | Captura de pantalla interactiva      |
| `keepassxc`  | Gestor de contraseñas seguro         |


## ⚡ Alias añadidos (`.zshrc`)

| Alias          | Función                                      |
|----------------|----------------------------------------------|
| `updateAndClean`| Actualiza y limpia el sistema               |
| `mkt`          | Crea carpetas `nmap`, `content`, `exploits` |
| `dockerClean`  | Limpia Docker (contenedores, imágenes, redes, volúmenes) |
| `rmk <archivo>`| Borra archivos con sobrescritura segura     |
| `target <IP>`  | Define IP/objetivo actual                   |
| `TU_USUARIO`   | Cambia de root a usuario normal             |
| `vulnhub`, `HTB`, `DKL` | Navega a carpetas de máquinas CTF rápidamente |


### 🎨 Nuevos Estilos Visuales de Comandos

#### UpdateAndClean - Nuevo Diseño

![UpdateAndClean](https://imgur.com/n6Dz9lm.png)


_Interfaz visual mejorada para actualizaciones del sistema_

---
#### DockerClean - Nuevo Estilo

![DockerClean](https://imgur.com/IjYaDGd.png)


_Presentación renovada para limpieza de Docker_

## ⌨️ Atajos de teclado

### GNOME

| Atajo                | Acción              |
|----------------------|---------------------|
| `Super + Enter`      | Abre Terminator     |
| `Super + Shift + F`  | Abre Firefox        |
| `Super + Shift + O`  | Abre Obsidian       |
| `Super + Shift + B`  | Abre Burpsuite      |
| `Super + E`          | Abre Nautilus       |
| `Print`              | Flameshot GUI       |

### Kitty

| Atajo                     | Acción                          |
|---------------------------|---------------------------------|
| Ctrl + Shift + E / O      | Divisiones vertical / horizontal |
| Ctrl + Shift + T / Q / W  | Nueva pestaña / cerrar / cerrar panel |
| F1 / F2                   | Copiar / pegar                  |
| Alt + flechas             | Mover entre paneles             |
| Ctrl + Shift + O + ↑/↓    | Ajustar opacidad                |
| Ctrl + I                  | Establecer nombre de pestaña    |

## 🖼️ Vista previa visual

### Fondo de pantalla - Actualización

![Wallpaper](https://imgur.com/l3ov8K9.jpeg)

### Escritorio GNOME - Actualización

![Escritorio](https://imgur.com/2R3zdKK.jpeg)

### Página de inicio de navegador - Actualización

![Browser Background](https://i.imgur.com/Ju4ANo5.png)

### Fondo GDM (bloqueo) - Actualización

![Update](https://imgur.com/xs4YYNa.png)

## 🎨 Prompt personalizado de ZSH
| Estado |Vista  |
|--|--|
| ✔ Éxito | ![OK](https://i.imgur.com/fNuGtBM.png) |
|✘ Error|![Error](https://i.imgur.com/oabJiCu.png)|
|VPN (Actualización)|![VPN](https://imgur.com/JuSeipc.png)|

Colores dinámicos según el resultado del último comando. Fuente: **JetBrainsMono**.

## 📁 LSD y SetTarget dinámico

-   Al ejecutar `settarget <ip> <nombre>`, se actualiza la información de **IP Víctima** y **Máquina Objetivo** en la terminal.
-   El prompt alterna entre los lemas **L3VIATH4N** y **H4PPY H4CK1NG** dinámicamente.

![lsd](https://i.imgur.com/LJPQ1hf.png)

## 🖥️ Terminales personalizadas

### Terminator

![Terminator](https://i.imgur.com/keN3dVv.jpeg)

### Kitty

![Kitty](https://i.imgur.com/apgMe29.jpeg)

## ✍️ Neovim (NvChad) - Actualizado v0.11

### 🚀 Nuevas características de Neovim 0.11:

-   **LSP mejorado**: Configuración más simple y eficiente
-   **Autocompletado nativo**: Integrado directamente en el core
-   **Mejor rendimiento**: Optimizaciones en tree-sitter
-   **Documentación hover mejorada**: Experiencia de desarrollo más fluida
-   **Terminal integrado mejorado**: Mejor emulación y funcionalidades

![Neovim](https://i.imgur.com/UoqShDn.png)

## 🔄 Registro de Cambios Recientes

### v2025.2 - Actualización Mayor

-   🆕 **Neovim 0.11** con todas las mejoras de LSP y rendimiento
-   🎨 **Interfaz visual renovada** para `updateAndClean` y `dockerClean`
-   🔧 **Correcciones de bugs** y optimizaciones de rendimiento
-   🌟 **Nuevas extensiones** integradas para mejor el pentesting

## 🧠 Notas finales

-   El script es modular y puede personalizarse para agregar más extensiones o herramientas.
-   El diseño está enfocado en pentesters y usuarios técnicos que buscan eficiencia sin sacrificar estética.
-   **Neovim 0.11** representa una mejora significativa en la experiencia de desarrollo con LSP nativo y mejor rendimiento.

# 🧠 H4PPY H4CK1NG
