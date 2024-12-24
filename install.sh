#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# =========================================
# Autor: Jordan Edilberto Cueva Mendoza
# Version 1.8
# =========================================

set -e

# Definición de colores
BOLD='\033[1m'
RESET='\033[0m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
RED='\033[0;31m'

# Variables globales
CURRENT_USER=$(whoami)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

# Funciones de utilidad
log_step() {
    echo -e "\n${YELLOW}${BOLD}▶ ${RESET}$1"
}

log_info() {
    echo -e "${BLUE}  [ℹ] ${RESET}$1"
}

log_success() {
    echo -e "${GREEN}  [✔] ${RESET}$1"
}

log_error() {
    echo -e "${RED}  [✖] $1${RESET}" >&2
}

nvim_install(){
  # Placeholder for nvim_install function
  log_info "Placeholder for nvim_install function"
}

show_banner() {
    clear
    echo -e "${CYAN}${BOLD}"
    echo "  _____   ____ _______ ______ _____ _      ______  _____           "
    echo " |  __ \\ / __ \\__   __|  ____|_   _| |    |  ____|/ ____|       "
    echo " | |  | | |  | | | |  | |__    | | | |    | |__  | (___            "
    echo " | |  | | |  | | | |  |  __|   | | | |    |  __|  \\___ \\        "
    echo " | |__| | |__| | | |  | |     _| |_| |____| |____ ____) |         "
    echo " |_____/ \\____/  |_|  |_|    |_____|______|______|_____/         "
    echo "                                                                   "
    echo -e "${RESET}${GREEN}                By:Jordan aka SkyW4r33x         "
    echo -e "${RESET}"
}

aliases() {
  clear
  log_info "Integrando aliases al ${YELLOW}${BOLD}.zshrc${RESET}.\n"
  
  # VARIABLES
  zshrc_ub="/home/${CURRENT_USER}/.zshrc"
  comentario='# --------------------------- Aliases pentester ---------------------------'
  utilscomon="alias utilscomon='clear && cat /home/${CURRENT_USER}/referencestuff/utilscommon | sed -e \"s/^#\$\$.*\$\$\$/\$(tput setaf 220)&\$(tput sgr0)/\" -e \"s/\[!\].*/\$(tput setaf 10)&\$(tput sgr0)/\" -e \"s/.*/\$(tput setaf 1)&\$(tput sgr0)/\"'"
  utilscommon1="alias utilscomon1='clear && cat /home/${CURRENT_USER}/referencestuff/utilscommon1 | sed -e \"s/^#\$\$.*\$\$\$/\$(tput setaf 220)&\$(tput sgr0)/\" -e \"s/\[!\].*/\$(tput setaf 10)&\$(tput sgr0)/\" -e \"s/.*/\$(tput setaf 1)&\$(tput sgr0)/\"'"
  treatty="alias treatty='clear && cat /home/${CURRENT_USER}/referencestuff/treatmentty | sed \"s/^/\$(tput setaf 1)/\" | sed \"s/\$/\$(tput sgr0)/\"'"
  vuln="alias vuln='clear && cat /home/${CURRENT_USER}/referencestuff/vulnsAttack | sed -e \"s/^#\$\$.*\$\$\$/\$(tput setaf 220)&\$(tput sgr0)/\" -e \"s/\[!\].*/\$(tput setaf 10)&\$(tput sgr0)/\" -e \"s/.*/\$(tput setaf 1)&\$(tput sgr0)/\"'"
  user="alias ${CURRENT_USER}='su ${CURRENT_USER}'"
  # ALIASES A INTEGRAR  
  aliases=(
    "$comentario"
    "$utilscomon"
    "$utilscommon1"
    "$treatty"
    "$vuln"
    "$user"
  )
  # extrae nombre de los aliases
  extraerAliases() {
    echo "$1" | awk '{print $2}' | awk -F '=' '{print $1}'
  }
  # agragar aliases
  for alias in "${aliases[@]}"; do 
    name_alias=$(extraerAliases "$alias")
    if ! grep -q "$alias" "$zshrc_ub"; then
      echo "$alias" >> "$zshrc_ub"
      log_success "Alias agregado: ${GREEN}${BOLD}$name_alias${RESET}"
      sleep 1
    else
      log_error "El alias ya existe: ${RED}${BOLD}$name_alias${RESET}"
    fi
  done
  log_step "Proceso completado correctamente. a tu ${zshrc_ub}"
}

ask_for_password() {
    log_step "Solicitando privilegios de superusuario"
    sudo -v || { log_error "No se pudo obtener privilegios de superusuario"; exit 1; }
}

# Funciones de instalación
install_neovim() {
    local is_root=$1
    local target_dir

    if [ "$is_root" = true ]; then
        target_dir="/root/.config/nvim"
    else
        target_dir="$HOME/.config/nvim"
    fi

    if [ -f "$SCRIPT_DIR/nvim-linux64.tar.gz" ]; then
        log_info "Copiando nvim-linux64.tar.gz a /opt/"
        sudo cp "$SCRIPT_DIR/nvim-linux64.tar.gz" /opt/ || { log_error "Error al copiar nvim-linux64.tar.gz"; return 1; }
        
        log_info "Descomprimiendo Neovim en /opt/"
        sudo tar xzf /opt/nvim-linux64.tar.gz -C /opt/ || { log_error "Error al descomprimir Neovim"; return 1; } 
   
        log_success "Neovim v0.10.0 instalado correctamente"

        log_info "Instalando NvChad en $target_dir"
        if [ -d "$target_dir" ]; then
            log_info "Respaldo de configuración existente en $target_dir.bak"
            sudo mv "$target_dir" "$target_dir.bak" || { log_error "Error al hacer backup de la configuración existente"; return 1; }
        fi
        sudo git clone https://github.com/NvChad/starter "$target_dir" || {
            log_error "Error al clonar el repositorio de NvChad"; return 1;
        }
        log_success "NvChad instalado en $target_dir"
    else
        log_error "No se encontró nvim-linux64.tar.gz en el directorio del script"
        return 1
    fi
}

install_for_user() {
    local user=$1
    local is_root=$2
    local sudo_prefix=""
    [ "$is_root" = true ] && sudo_prefix="sudo -i"

    $sudo_prefix bash << 'EOFUSER'
    BOLD='\033[1m'
    RESET='\033[0m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    BLUE='\033[0;34m'
    RED='\033[0;31m'

    log_step() {
        echo -e "\n${YELLOW}${BOLD}▶ $1${RESET}"
    }

    log_info() {
        echo -e "${BLUE}  [ℹ] ${RESET}$1"
    }

    log_success() {
        echo -e "${GREEN}  [✔] ${RESET}$1"
    }

    log_error() {
        echo -e "${RED}  [✖] $1${RESET}" >&2
    }
    
    log_step "Instalando para ${USER}"
    
    log_info "Instalando fzf"
    if [ "${USER}" = "root" ]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git /root/.fzf || { log_error "Error al clonar fzf para root"; exit 1; }
        /root/.fzf/install --all || { log_error "Error al instalar fzf para root"; exit 1; }
    else
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf || { log_error "Error al clonar fzf para usuario"; exit 1; }
        ~/.fzf/install --all || { log_error "Error al instalar fzf para usuario"; exit 1; }
    fi
    log_success "fzf instalado"
EOFUSER
}

# Función principal
main() {

    [ "$EUID" -eq 0 ] && { log_error "No ejecutes este script como root"; exit 1; }

    show_banner

    log_step "Iniciando instalación para $CURRENT_USER"

    if [ -f "$HOME/.zshrc" ]; then
        log_info "Haciendo backup de .zshrc existente"
        mv "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)" || { log_error "Error al hacer backup de .zshrc"; exit 1; }
    fi

    log_info "Copiando archivos de configuración"
    cp "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc" || { log_error "Error al copiar .zshrc"; exit 1; }
    cp -r "$SCRIPT_DIR/referencestuff" "$HOME/" || { log_error "Error al copiar referencestuff"; exit 1; }

    # Copiar carpeta bin a .config del usuario
    if [ -d "$SCRIPT_DIR/bin" ]; then
        log_info "Copiando carpeta bin a .config del usuario"
        mkdir -p "$CONFIG_DIR"
        cp -r "$SCRIPT_DIR/bin" "$CONFIG_DIR/" || { log_error "Error al copiar carpeta bin a .config"; exit 1; }
        log_success "Carpeta bin copiada a .config del usuario"
    else
        log_error "No se encontró la carpeta bin en el directorio del script"
    fi

    # Agregar función settarget al .zshrc
    log_info "Agregando función settarget al .zshrc"
    mkdir -p "/home/$CURRENT_USER/.config/bin/target"
    cat << EOF >> "$HOME/.zshrc"

# settargeted
function settarget(){
    ip_address=\$1
    machine_name=\$2
    echo "\$ip_address \$machine_name" > "/home/$CURRENT_USER/.config/bin/target/target.txt"
}
EOF
    log_success "Función settarget agregada al .zshrc"

    log_success "Archivos de configuración copiados"

    install_for_user "$CURRENT_USER" false

    log_success "Instalación para $CURRENT_USER completada"

    ask_for_password

    log_step "Iniciando instalación para root"

    sudo -i bash -c "ln -sf /home/${CURRENT_USER}/.zshrc .zshrc" || { log_error "Error al crear enlace simbólico de .zshrc para root"; exit 1; }
    log_success "Enlace simbólico de .zshrc creado para root"

    install_for_user "root" true

    log_info "Instalando Neovim para $CURRENT_USER"
    install_neovim false || { log_error "Error al instalar Neovim para $CURRENT_USER"; exit 1; }

    log_info "Instalando Neovim para root"
    install_neovim true || { log_error "Error al instalar Neovim para root"; exit 1; }

    log_info "Instalando herramientas adicionales"
    sudo apt update && sudo apt install -y lsd bat terminator keepassxc || { log_error "Error al instalar herramientas adicionales"; exit 1; }
    log_success "Herramientas adicionales instaladas"

    log_info "Instalando fuente JetBrainsMono"
    sudo mkdir -p /usr/share/fonts/JetBrainsMono || { log_error "Error al crear directorio para JetBrainsMono"; exit 1; }
    sudo unzip -o "$SCRIPT_DIR/JetBrainsMono.zip" -d /usr/share/fonts/JetBrainsMono/ || { log_error "Error al descomprimir JetBrainsMono"; exit 1; }
    sudo fc-cache -f -v || { log_error "Error al actualizar cache de fuentes"; exit 1; }
    log_success "Fuente JetBrainsMono instalada"

    if [ -d "$SCRIPT_DIR/sudo-plugin" ]; then
        log_info "Instalando plugin de zsh"
        sudo mkdir -p /usr/share/sudo-plugin || { log_error "Error al crear directorio para sudo-plugin"; exit 1; }
        sudo cp -r "$SCRIPT_DIR/sudo-plugin/"* /usr/share/sudo-plugin/ || { log_error "Error al copiar sudo-plugin"; exit 1; }
        sudo chown -R ${CURRENT_USER}:${CURRENT_USER} /usr/share/sudo-plugin || { log_error "Error al cambiar propietario de sudo-plugin"; exit 1; }
        log_success "Plugin de zsh instalado"
    else
        log_error "No se encontró el directorio sudo-plugin"
    fi
    
    sleep 1.5
    clear
    aliases
    clear
    sleep 1.5

    echo -e "\n${GREEN}${BOLD}.:: Instalación completada con éxito ::.${RESET}"

    echo -e "\n${CYAN}${BOLD}[+] Recomendaciones y características:${RESET}"
    echo -e "${YELLOW}  • Neovim:${RESET} Ejecuta ${BLUE}${BOLD}nvim${RESET} para comenzar la personalizacion con ${BLUE}${BOLD}NvChad${RESET}"
    echo -e "${YELLOW}  • ZSH:${RESET} Reinicia tu terminal para aplicar los cambios"
    echo -e "${YELLOW}  • Herramientas:${RESET} Prueba las nuevas herramientas: lsd, bat y terminator keepassxc"
    echo -e "${YELLOW}  • FZF:${RESET} Usa Ctrl+R para búsqueda en el historial y Ctrl+T para búsqueda de archivos"
    echo -e "${YELLOW}  • Actualización:${RESET} Usa ${BLUE}${BOLD}updateAndclean${RESET} para actualizar y limpiar automáticamente el sistema"
    echo -e "${YELLOW}  • Docker:${RESET} Usa ${BLUE}${BOLD}dockerClean${RESET} para limpiar contenedores"
    echo -e "${YELLOW}  • Settarget:${RESET} Usa ${BLUE}${BOLD}settarget <ip> <nombre>${RESET} para establecer el objetivo"
    echo -e "\n${CYAN}${BOLD}[+] Utilidades Pentesting:${RESET}"
    echo -e "${YELLOW}  • Comandos:${RESET} Guías de comandos útiles disponibles con ${RED}${BOLD}utilscommon${RESET} y ${RED}${BOLD}utilscommon1${RESET}"
    echo -e "${YELLOW}  • TTY:${RESET} Guia de mejora de la TTY de la maquina victima usando ${YELLOW}${BOLD}treatty${RESET}"
    echo -e "${YELLOW}  • Vulnerabilidades:${RESET} Con el comando ${YELLOW}${BOLD}vuln${RESET} lista ayuda de algunas Vulnerabilidades"
    echo -e "${YELLOW}  • Configuración:${RESET} Revisa el archivo .zshrc para entender y personalizar tu configuración"

    echo -e "\n${GREEN}${BOLD}.:: ¡Disfruta de tu nuevo entorno personalizado! ::.${RESET}\n"
}

# iniciar script
main
