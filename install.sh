#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# =========================================
# Author: Jordan Edilberto Cueva Mendoza
# Version 2.3
# =========================================

set -euo pipefail

# Colors and styles
RESET='\033[0m'
BOLD='\033[1m'

# Regular colors
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
ORANGE='\033[38;5;208m'

# Global variables
CURRENT_USER=$(logname)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="/home/$CURRENT_USER/.config"

print_message() {
    local color=$1
    local prefix=$2
    local message=$3
    echo -e "${color}${BOLD}$prefix ${RESET}$message"
    sleep 0.2
}

title() {
    local title_text="$1"
    echo
    echo -e "${BLUE}${BOLD}════ $title_text ════${RESET}"
}

text() {
    echo -e "  ${YELLOW}${BOLD}[•] $1${RESET}"
}

update_version_title() {
    echo
    echo -e "${GREEN}${BOLD}🚀 $1 🚀${RESET}"
}

update_version_text() {
    echo -e "  ${CYAN}${BOLD}▸${RESET} $1"
}

log_step() {
    local text="$1"
    local text_length=${#text}
    local min_length=35
    local max_length=45
    local separator_length=$((text_length + 4))

    # Asegurar que el separador no sea muy corto o muy largo
    if [ $separator_length -lt $min_length ]; then
        separator_length=$min_length
    elif [ $separator_length -gt $max_length ]; then
        separator_length=$max_length
    fi

    local separator=$(printf '═%.0s' $(seq 1 $separator_length))

    echo -e "\n${RED}${BOLD}▶ ${RESET}$text"
    echo -e "${RED}${BOLD}$separator${RESET}"
}

log_info() {
    echo -e "${BLUE}${BOLD}[ℹ] ${RESET}$1"
    sleep 0.2
}

log_success() {
    echo -e "${GREEN}${BOLD}[✓] ${RESET}$1"
    sleep 0.2
}

log_error() {
    echo -e "${RED}${BOLD}[✗] ${RESET}$1" >&2
}

show_banner() {
    clear
    echo -e "${RED}${BOLD}"
    cat << "EOF"
██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝
EOF
    echo -e "${RESET}"
    echo
    print_message "${ORANGE}" "Realizado por:" "Jordan (aka SkyW4r33x)"
    print_message "${ORANGE}" "Versión:" "2.3"
    print_message "${ORANGE}" "Repositorio:" "https://github.com/SkyW4r33x"
    echo
    sleep 2
}

aliases() {
    log_info "Integrando aliases al ${YELLOW}${BOLD}.zshrc${RESET}.\n"
    
    local zshrc_ub="/home/${CURRENT_USER}/.zshrc"
    local comentario='# --------------------------- Aliases pentester ---------------------------'
    local aliases=(
        "$comentario"
        "alias utilscomon='clear && cat /home/${CURRENT_USER}/referencestuff/utilscommon | sed -e \"s/^#\$\$.*\$\$\$/\$(tput setaf 220)&\$(tput sgr0)/\" -e \"s/\[!\].*/\$(tput setaf 10)&\$(tput sgr0)/\" -e \"s/.*/\$(tput setaf 1)&\$(tput sgr0)/\"'"
        "alias utilscomon1='clear && cat /home/${CURRENT_USER}/referencestuff/utilscommon1 | sed -e \"s/^#\$\$.*\$\$\$/\$(tput setaf 220)&\$(tput sgr0)/\" -e \"s/\[!\].*/\$(tput setaf 10)&\$(tput sgr0)/\" -e \"s/.*/\$(tput setaf 1)&\$(tput sgr0)/\"'"
        "alias treatty='clear && cat /home/${CURRENT_USER}/referencestuff/treatmentty | sed \"s/^/\$(tput setaf 1)/\" | sed \"s/\$/\$(tput sgr0)/\"'"
        "alias vuln='clear && cat /home/${CURRENT_USER}/referencestuff/vulnsAttack | sed -e \"s/^#\$\$.*\$\$\$/\$(tput setaf 220)&\$(tput sgr0)/\" -e \"s/\[!\].*/\$(tput setaf 10)&\$(tput sgr0)/\" -e \"s/.*/\$(tput setaf 1)&\$(tput sgr0)/\"'"
        "alias ${CURRENT_USER}='su ${CURRENT_USER}'"
    )

    for alias in "${aliases[@]}"; do 
        if [ "$alias" = "$comentario" ]; then
            echo "$alias" >> "$zshrc_ub"
        else
            local name_alias=$(echo "$alias" | awk '{print $2}' | awk -F '=' '{print $1}')
            if ! grep -q "$alias" "$zshrc_ub"; then
                echo "$alias" >> "$zshrc_ub"
                log_success "Alias agregado: ${GREEN}${BOLD}$name_alias${RESET}"
            else
                log_error "El alias ya existe: ${RED}${BOLD}$name_alias${RESET}"
            fi
        fi
    done
    log_step "Aliases de arsenal de comandos integrados al .zshrc correctamente. ${zshrc_ub}"
}

install_neovim() {
    local install_dir=$1
    local is_root=$2

    if [ "$is_root" = true ]; then
        if [ -f "$SCRIPT_DIR/nvim-linux64.tar.gz" ]; then
            log_info "Instalando Neovim..."
            sudo cp "$SCRIPT_DIR/nvim-linux64.tar.gz" /opt/ && 
            sudo tar xzf /opt/nvim-linux64.tar.gz -C /opt/ > /dev/null 2>&1 || 
            { log_error "Error al instalar Neovim"; return 1; }
            log_success "Neovim v0.10.0 instalado correctamente"

            log_info "Instalando NvChad en $install_dir"
            if [ -d "$install_dir" ]; then
                sudo mv "$install_dir" "${install_dir}.bak" > /dev/null 2>&1 || 
                { log_error "Error al hacer backup de la configuración existente"; return 1; }
            fi
            
            sudo mkdir -p "$install_dir"
            sudo git clone https://github.com/NvChad/starter "$install_dir" > /dev/null 2>&1 || 
            { log_error "Error al clonar el repositorio de NvChad para root"; return 1; }
            log_success "NvChad instalado en $install_dir"
        else
            log_error "No se encontró nvim-linux64.tar.gz en el directorio del script"
            return 1
        fi
    else
        log_info "Instalando NvChad para ${BLUE}${BOLD}${CURRENT_USER}${RESET}"
        git clone https://github.com/NvChad/starter ~/.config/nvim > /dev/null 2>&1 || 
        { log_error "Error al clonar NvChad para usuario normal"; return 1; }
        log_success "NvChad instalado correctamente para ${BLUE}${BOLD}${CURRENT_USER}${RESET}"
    fi
}

install_fzf() {
    local user=$1
    local home_dir="/home/$user"
    [ "$user" = "root" ] && home_dir="/root"

    # Definir colores para el usuario
    local user_color="${BLUE}"
    [ "$user" = "root" ] && user_color="${RED}"

    if [ ! -d "${home_dir}/.fzf" ]; then
        log_info "Instalando fzf para ${user_color}${BOLD}$user${RESET}"
        if [ "$user" = "root" ]; then
            sudo git clone --depth 1 https://github.com/junegunn/fzf.git "${home_dir}/.fzf" > /dev/null 2>&1 || 
            { log_error "Error al clonar fzf para ${user_color}${BOLD}$user${RESET}"; return 1; }
            
            sudo "${home_dir}/.fzf/install" --all --no-bash --no-fish > /dev/null 2>&1 || 
            { log_error "Error al instalar fzf para ${user_color}${BOLD}$user${RESET}"; return 1; }
        else
            git clone --depth 1 https://github.com/junegunn/fzf.git "${home_dir}/.fzf" > /dev/null 2>&1 || 
            { log_error "Error al clonar fzf para ${user_color}${BOLD}$user${RESET}"; return 1; }
            
            chown -R "${user}:${user}" "${home_dir}/.fzf" > /dev/null 2>&1 || 
            { log_error "Error al ajustar permisos de fzf"; return 1; }
            
            sudo -u "$user" bash -c "cd ${home_dir}/.fzf && ./install --all --no-bash --no-fish > /dev/null 2>&1" || 
            { log_error "Error al instalar fzf para ${user_color}${BOLD}$user${RESET}"; return 1; }
        fi
        
        log_success "fzf instalado correctamente para ${user_color}${BOLD}$user${RESET}"
    else
        log_info "fzf ya está instalado para ${user_color}${BOLD}$user${RESET}"
    fi
}


install_extract_ports() {
    log_step "Iniciando la instalación de extractPorts modificado"
    
    log_info "Instalando extractPorts..."
    chmod +x "$SCRIPT_DIR/extractPorts.py" && 
    sudo cp "$SCRIPT_DIR/extractPorts.py" "/usr/bin/extractPorts.py" && 
    sudo chmod +x "/usr/bin/extractPorts.py" || 
    { log_error "Error al instalar extractPorts.py"; return 1; }

    if command -v extractPorts.py &> /dev/null; then
        log_success "extractPorts.py se ha instalado correctamente y está disponible en el PATH"
        sleep 2
    else
        log_error "La instalación de extractPorts.py ha fallado o no está en el PATH"
        return 1
    fi
}

setup_user_environment() {
    log_step "Configurando entorno para ${BLUE}${BOLD}$CURRENT_USER${RESET}"

    if [ -f "$HOME/.zshrc" ]; then
        log_info "Haciendo backup de .zshrc existente"
        mv "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)" || { log_error "Error al hacer backup de .zshrc"; exit 1; }
    fi

    log_info "Copiando archivos de configuración"
    cp "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc" && 
    cp -r "$SCRIPT_DIR/referencestuff" "$HOME/" || 
    { log_error "Error al copiar archivos de configuración"; exit 1; }

    if [ -d "$SCRIPT_DIR/bin" ]; then
        log_info "Copiando carpeta bin a .config para ${BLUE}${BOLD}${CURRENT_USER}${RESET}"
        mkdir -p "$CONFIG_DIR" && 
        cp -r "$SCRIPT_DIR/bin" "$CONFIG_DIR/" || 
        { log_error "Error al copiar carpeta bin a .config"; exit 1; }
        log_success "Carpeta bin copiada a .config para ${BLUE}${BOLD}${CURRENT_USER}${RESET}"
    else
        log_error "No se encontró la carpeta bin en el directorio del script"
    fi

    log_info "Agregando función settarget al .zshrc"
    mkdir -p "$CONFIG_DIR/bin/target"
    cat << EOF >> "$HOME/.zshrc"

# settargeted
function settarget(){
    ip_address=\$1
    machine_name=\$2
    echo "\$ip_address \$machine_name" > "$CONFIG_DIR/bin/target/target.txt"
}
EOF
    log_success "Función settarget agregada al .zshrc"

    log_success "Archivos de configuración copiados"

    install_fzf "$CURRENT_USER"
    install_neovim "$CONFIG_DIR/nvim" false

    log_success "Configuración para ${BLUE}${BOLD}$CURRENT_USER${RESET} completada"
}

setup_root_environment() {
    log_step "Configurando entorno para ${RED}${BOLD}root${RESET}"

    sudo -i bash -c "ln -sf /home/${CURRENT_USER}/.zshrc .zshrc" || { log_error "Error al crear enlace simbólico de .zshrc para ${RED}${BOLD}root${RESET}"; exit 1; }
    log_success "Enlace simbólico de .zshrc creado para ${RED}${BOLD}root${RESET}"

    install_fzf "root"
    install_neovim "/root/.config/nvim" true

    log_success "Configuración para ${RED}${BOLD}root${RESET} completada"
}

install_additional_tools() {
    log_info "Instalando herramientas adicionales: lsd, bat, terminator, keepassxc, xclip"
    sudo apt update > /dev/null 2>&1 && 
    sudo apt install -y lsd bat terminator keepassxc xclip > /dev/null 2>&1 || 
    { log_error "Error al instalar herramientas adicionales"; exit 1; }
    log_success "Herramientas adicionales instaladas"

    log_info "Instalando fuente JetBrainsMono"
    sudo mkdir -p /usr/share/fonts/JetBrainsMono && 
    sudo unzip -o "$SCRIPT_DIR/JetBrainsMono.zip" -d /usr/share/fonts/JetBrainsMono/ > /dev/null 2>&1 && 
    sudo fc-cache -f -v > /dev/null 2>&1 || 
    { log_error "Error al instalar la fuente JetBrainsMono"; exit 1; }
    log_success "Fuente JetBrainsMono instalada"

    if [ -d "$SCRIPT_DIR/sudo-plugin" ]; then
        log_info "Instalando plugin de zsh"
        sudo mkdir -p /usr/share/sudo-plugin && 
        sudo cp -r "$SCRIPT_DIR/sudo-plugin/"* /usr/share/sudo-plugin/ && 
        sudo chown -R ${CURRENT_USER}:${CURRENT_USER} /usr/share/sudo-plugin || 
        { log_error "Error al instalar el plugin de zsh"; exit 1; }
        log_success "Plugin de zsh instalado"
    else
        log_error "No se encontró el directorio sudo-plugin"
    fi

    install_extract_ports || { log_error "Error al instalar extractPorts"; exit 1; }
}

main() {
    if [ "$EUID" -eq 0 ]; then
        log_error "No ejecutes este script como root"
        exit 1
    fi

    show_banner

    setup_user_environment

    log_step "Solicitando privilegios de ${RED}${BOLD}root${RESET}"
    sudo -v || { log_error "No se pudo obtener privilegios de root"; exit 1; }
    clear
    setup_root_environment
    install_additional_tools

    sleep 1.5
    clear
    aliases
    clear
    sleep 1.5

    echo -e "\n${MAGENTA}${BOLD}.:: Instalación completada con éxito ::.${RESET}"

    title "Recomendaciones y características"
    text "Neovim:${RESET} Ejecuta ${BLUE}${BOLD}nvim${RESET} para comenzar la personalización con ${BLUE}${BOLD}NvChad${RESET}"
    text "ZSH:${RESET} Reinicia tu terminal para aplicar los cambios"
    text "Herramientas:${RESET} Prueba las nuevas herramientas: ${BLUE}${BOLD}lsd, bat, terminator, keepassxc, xclip${RESET}"
    text "FZF:${RESET} Usa ${BLUE}${BOLD}Ctrl+R${RESET} para búsqueda en el historial y ${BLUE}${BOLD}Ctrl+T${RESET} para búsqueda de archivos"
    text "Actualización:${RESET} Usa ${BLUE}${BOLD}updateAndclean${RESET} para actualizar y limpiar automáticamente el sistema"
    text "Docker:${RESET} Usa ${BLUE}${BOLD}dockerClean${RESET} para limpiar contenedores"
    text "Settarget:${RESET} Usa ${BLUE}${BOLD}settarget <ip> <nombre>${RESET} para establecer el objetivo" 

    echo "" 

    title "Utilidades Pentesting"
    text "Comandos:${RESET} Guías de comandos útiles disponibles con ${RED}${BOLD}utilscommon${RESET} y ${RED}${BOLD}utilscommon1${RESET}"
    text "TTY:${RESET} Guía de mejora de la TTY de la máquina víctima usando ${RED}${BOLD}treatty${RESET}"
    text "Vulnerabilidades:${RESET} Con el comando ${RED}${BOLD}vuln${RESET} lista ayuda de algunas vulnerabilidades"
    text "Configuración:${RESET} Revisa el archivo ${BLUE}${BOLD}.zshrc${RESET} para entender y personalizar tu configuración"

    echo ""

    update_version_title "Actualización"
    update_version_text "Herramienta ${BLUE}${BOLD}extractPorts${RESET} mejorada e integrada."
    update_version_text "Para usar la utilidad, ejecuta ${BLUE}${BOLD}extractPorts${RESET} en la terminal."

}

main
