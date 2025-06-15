# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ~/.zshrc file for zsh interactive shells.
# see /usr/share/doc/zsh/examples/zshrc for examples

setopt autocd              # change directory just by typing its name
#setopt correct            # auto correct mistakes
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt

WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word

# hide EOL sign ('%')
PROMPT_EOL_MARK=""

# configure key keybindings
bindkey -e                                        # emacs key bindings
bindkey ' ' magic-space                           # do history expansion on space
bindkey '^U' backward-kill-line                   # ctrl + U
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action

# enable completion features
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
#setopt share_history         # share command history data

# force zsh to show the complete history
alias history="history 0"

# configure `time` format
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# Función para detectar VPN activa y obtener IP
vpn_status() {
  if ip addr show tun0 &>/dev/null; then
    vpn_ip=$(ip addr show tun0 | awk '/inet / {print $2}' | cut -d'/' -f1 | head -1)
    [[ -n "$vpn_ip" ]] && echo -n "-[%F{white}%B${vpn_ip}%b%F{%(#.blue.green)}]" || echo -n ""
  else
    echo -n ""
  fi
}

configure_prompt() {
    prompt_symbol=㉿
    prompt_folder=󰋜 
    prompt_kali=   
    # Skull emoji for root terminal
    #[ "$EUID" -eq 0 ] && prompt_symbol=💀
    case "$PROMPT_ALTERNATIVE" in
        twoline)
            # Prompt original con segmento VPN dinámico
            PROMPT=$'%F{%(#.blue.green)}┌──[%F{white}'$prompt_kali$'%F{%(#.blue.green)} ]-(%B%F{%(#.red.blue)}%n%b%F{%(#.blue.green)})%{$(vpn_status)%}-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]-[%(?.%F{green}✔.%F{red}✘ %?)%F{%(#.blue.green)}]\n└──╼%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '
            # Right-side prompt with exit codes and background processes
            #RPROMPT=$'%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{yellow}%B⚙%b%F{reset}.)'
            ;;
        oneline)
            PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{%(#.red.blue)}%n@%m%b%F{reset}:%B%F{%(#.blue.green)}%~%b%F{reset}%(#.#.$) '
            RPROMPT=
            ;;
        backtrack)      
            #PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{#3464eb}%n'$prompt_symbol'%m%b%F{#EC0101}:%B%F{#ffffff}%~%b%F{#EC0101}%(#.#.$)%f '
            #PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{#3464eb}%n%b%F{#EC0101}:%B%F{#ffffff}%~%b%F{#EC0101}%(#.#.$)%f '
            RPROMPT=
            ;;
    esac
    unset prompt_symbol
}

# The following block is surrounded by two delimiters.
# These delimiters must not be modified. Thanks.
# START KALI CONFIG VARIABLES
PROMPT_ALTERNATIVE=twoline
NEWLINE_BEFORE_PROMPT=yes
# STOP KALI CONFIG VARIABLES

if [ "$color_prompt" = yes ]; then
    # override default virtualenv indicator in prompt
    VIRTUAL_ENV_DISABLE_PROMPT=1

    configure_prompt

    # enable syntax-highlighting
    if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
        ZSH_HIGHLIGHT_STYLES[default]=none
        ZSH_HIGHLIGHT_STYLES[unknown-token]=underline
        ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
        ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[global-alias]=fg=green,bold
        ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[path]=bold
        ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[command-substitution]=none
        ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[process-substitution]=none
        ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=green
        ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=green
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[assign]=none
        ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
        ZSH_HIGHLIGHT_STYLES[named-fd]=none
        ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
        ZSH_HIGHLIGHT_STYLES[arg0]=fg=cyan
        ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
        ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
    fi
else
    PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~%(#.#.$) '
fi
unset color_prompt force_color_prompt

toggle_oneline_prompt(){
    if [ "$PROMPT_ALTERNATIVE" = oneline ]; then
        PROMPT_ALTERNATIVE=twoline
    else
        PROMPT_ALTERNATIVE=oneline
    fi
    configure_prompt
    zle reset-prompt
}
zle -N toggle_oneline_prompt
bindkey ^P toggle_oneline_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty)
    TERM_TITLE=$'\e]0;${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%n@%m: %~\a'
    ;;
*)
    ;;
esac

precmd() {
    # Print the previously configured title
    print -Pnr -- "$TERM_TITLE"

    # Print a new line before the prompt, but only if it is not the first line
    if [ "$NEWLINE_BEFORE_PROMPT" = yes ]; then
        if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
            _NEW_LINE_BEFORE_PROMPT=1
        else
            print ""
        fi
    fi
}

# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions

    #alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

    # Take advantage of $LS_COLORS for completion as well
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
fi

# some more ls aliases
### LS & TREE
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -F'
#command -v lsd > /dev/null && alias ls='clear && lsd --group-dirs first --color=never' && \
# Utilidades de visualización de archivos y directorios
alias tree='lsd --tree'
if command -v colorls > /dev/null; then
    alias ls='colorls --sd --gs'
    alias tree='colorls --tree'
fi

# Mejoras de visualización de contenido
alias cat='batcat --theme=ansi --style=numbers,changes,header --pager=never'

# Personalización de comandos del sistema
alias neofetch='neofetch | lolcat'
alias rmh='rmk ~/.zsh_history'
alias fucking='sudo su'
alias _='sudo su'

# Operaciones de archivos
alias cp='cp -rfv'
alias rm='rm -rf'
alias mv='mv -iv'

# Navegación rápida
alias vulnhub='clear && cd /root/machines_vuln/vulnhub'
alias HTB='clear && cd /root/machines_vuln/HTB'
alias DKL='clear && cd /root/machines_vuln/DockerLabs'

# Herramientas específicas
alias extractPorts='/usr/bin/extractPorts.py'

# Mejoras de ayuda
alias -g -- --help='--help 2>&1 | bat --theme=ansi --language=help --style=plain'
#alias -g -- -h='-h 2>&1 | bat --theme=ansi --language=help --style=plain'

# Configuración del editor
if command -v vim > /dev/null; then
    alias vim='/opt/nvim-linux64/bin/nvim'
    alias vi='/opt/nvim-linux64/bin/nvim'
fi

alias target='setup_target'
# ---------------------------------------- Custom LSD ---------------------------------------- #
# Archivo para almacenar el estado del mensaje
MESSAGE_STATE_FILE="${HOME}/.lsd_message_state"

#directorio del usuario no root
get_user_home() {
  if [ "$(id -u)" -eq 0 ]; then
    echo "$(awk -F: '$3 >= 1000 && $3 != 65534 {print $6; exit}' /etc/passwd)"
  else
    echo "$HOME"
  fi
}

function _base_ls() {
  local command=$1
  clear
  local reset=$'\e[0m'
  local bold=$'\e[1m'
  local bright_red=$'\e[1;31m'
  local bright_cyan=$'\e[1;36m'
  local bright_yellow=$'\e[1;33m'
  local bright_blue=$'\e[94m'
  local green=$'\e[38;2;25;131;136m'
  local cursiva=$'\e[3m'
  local blink=$'\e[5m'

  #IP de la víctima
  get_victim_ip() {
    local user_home=$(get_user_home)
    local ip_file="${user_home}/.config/bin/target/target.txt"
    if [ -f "$ip_file" ] && [ -s "$ip_file" ]; then
      awk '{print $1}' "$ip_file" | grep -v '^$' || echo "Unknown"
    else
      echo "Unknown"
    fi
  }

  # nombre de la víctima
  get_victim_name() {
    local user_home=$(get_user_home)
    local ip_file="${user_home}/.config/bin/target/target.txt"
    if [ -f "$ip_file" ] && [ -s "$ip_file" ]; then
      awk '{print $2}' "$ip_file" | grep -v '^$' || echo "Anonymous"
    else
      echo "Anonymous"
    fi
  }

  # IP y nombre de la víctima
  local victim_ip=$(get_victim_ip)
  local victim_name=$(get_victim_name)

  toggle_message() {
    if [ ! -f "$MESSAGE_STATE_FILE" ] || [ "$(cat "$MESSAGE_STATE_FILE")" = "L3VIATH4N" ]; then
      echo "H4PPY H4CK1NG" > "$MESSAGE_STATE_FILE"
      echo "${bold}${bright_yellow}H4PPY H4CK1NG${reset}"
    else
      echo "L3VIATH4N" > "$MESSAGE_STATE_FILE"
      echo "${bold}${bright_yellow}  L3VIATH4N${reset}"
    fi
  }

  echo
  echo -e "${bold}${bright_blue}╔═════════════════════════════════════[ INFORMACION DEL SISTEMA ]════════════════════════════════╗${reset}"
  echo -e "${bold}${bright_blue}                                                                                                            ${reset}"
  echo -e "${bold}${bright_blue}       ${bright_cyan}[${bright_yellow}✓${reset}${bright_cyan}]${reset}${bold} Ubicación${reset}......: ${cursiva}${green} $(pwd)${reset}"
  echo -e "${bold}${bright_blue}       ${bright_cyan}[${bright_yellow}✓${reset}${bright_cyan}]${reset}${bold} Fecha/Hora${reset}.....: ${cursiva}${green}󰸗 $(date '+%Y-%m-%d')${reset}\t   │\t${bright_yellow}   [${bright_red}${blink}!${reset}${bright_yellow}]${reset}${bold} Máquina Víctima${reset}.: ${bright_red}${cursiva}󰯐 ${victim_name}${reset}"
  echo -e "${bold}${bright_blue}       ${bright_cyan}[${bright_yellow}✓${reset}${bright_cyan}]${reset}${bold} IP Atacante${reset}....: ${cursiva}${green}󰩠 $(hostname -I | awk '{print $1}')${reset}\t   │\t${bright_yellow}   [${bright_red}${blink}!${reset}${bright_yellow}]${reset}${bold} IP Víctima${reset}......: ${bright_red}${cursiva}󰩠 ${victim_ip}${reset}"
  echo -e "${bold}${bright_blue}       ${bright_cyan}[${bright_yellow}✓${reset}${bright_cyan}]${reset}${bold} Usuario${reset}........: ${cursiva}${green} $(whoami)${reset}"
  echo -e "${bold}${bright_blue}                                             $(toggle_message)                                            ${reset}"
  echo -e "${bold}${bright_blue}╠═════════════════════════════════════[ CONTENIDO DEL DIRECTORIO ]═══════════════════════════════╣${reset}"
  echo

  lsd $command --color=always --icon=auto

  echo
  echo -e "${bold}${bright_blue}╚════════════════════════════════════════════════════════════════════════════════════════════════╝${reset}"
}

function ls() {
  _base_ls ""
}

function la() {
  _base_ls "-lA"
}

function l() {
  _base_ls "-l"
}

function ll() {
  _base_ls "-l"
}
# ------------------------------------- Actualizando Sistema ---------------------------------- #
updateAndClean() {
  # Definir colores y estilos
  local BOLD='\033[1m'
  local RESET='\033[0m'
  local GREEN='\033[0;32m'
  local YELLOW='\033[0;33m'
  local BLUE='\033[0;34m'
  local MAGENTA='\033[0;35m'
  local CYAN='\033[0;36m'
  local RED='\033[0;31m'
  # Solicitar contraseña de root al inicio
  echo -e "${YELLOW}${BOLD}Por favor, ingrese la contraseña de root para continuar:${RESET}"
  sudo -v
  # Verificar si se proporcionó la contraseña correctamente
  if [ $? -ne 0 ]; then
    echo -e "${RED}${BOLD}Error: No se proporcionó la contraseña de root correctamente. Abortando.${RESET}"
    return 1
  fi
  # Limpiar pantalla
  clear
  # Función auxiliar para ejecutar comandos
  ejecutar_comando() {
    echo -e "${CYAN}${BOLD}Ejecutando:${RESET} $1"
    if eval "$1"; then
      echo -e "${GREEN}[✓] $2${RESET}"
    else
      echo -e "${RED}${BOLD}[✗] Error al ejecutar: $1${RESET}"
    fi
  }
  # Cabecera
  echo -e "\n\t\t${BLUE}${BOLD}.:: Actualización y Limpieza Automática ::.\n${RESET}"
  # Actualizar lista de paquetes
  echo -e "${YELLOW}${BOLD}[1/7] Actualizando la lista de paquetes disponibles...${RESET}"
  ejecutar_comando "sudo apt update" "Lista de paquetes actualizada correctamente."
  # Actualizar sistema
  echo -e "\n${YELLOW}${BOLD}[2/7] Actualizando el sistema...${RESET}"
  ejecutar_comando "sudo apt upgrade -y" "Sistema actualizado correctamente."
  # Actualizar paquetes de distribución
  echo -e "\n${YELLOW}${BOLD}[3/7] Actualizando paquetes de distribución...${RESET}"
  ejecutar_comando "sudo apt dist-upgrade -y" "Paquetes de distribución actualizados correctamente."
  # Eliminar paquetes innecesarios
  echo -e "\n${YELLOW}${BOLD}[4/7] Eliminando paquetes no necesarios...${RESET}"
  ejecutar_comando "sudo apt autoremove --purge -y" "Paquetes innecesarios eliminados correctamente."
  # Limpiar paquetes descargados
  echo -e "\n${YELLOW}${BOLD}[5/7] Limpiando paquetes descargados...${RESET}"
  ejecutar_comando "sudo apt clean" "Paquetes descargados limpiados correctamente."
  # Limpiar la caché de apt
  echo -e "\n${YELLOW}${BOLD}[6/7] Limpiando la caché de apt...${RESET}"
  ejecutar_comando "sudo apt autoclean" "Caché de apt limpiada correctamente."
  # Actualizar la base de datos de locate
  echo -e "\n${YELLOW}${BOLD}[7/7] Actualizando la base de datos de locate...${RESET}"
  ejecutar_comando "sudo updatedb" "Base de datos de locate actualizada correctamente."
  # Pie de página
  echo -e "\n${BLUE}${BOLD}\t.:: Sistema actualizado y limpiado correctamente. ::.${RESET}" 
}
# ------------------------------------- plugins ---------------------------------- #
source /usr/share/sudo-plugin/sudo.plugin.zsh
# ------------------------------------- Funciones Generales ---------------------------------- #
# Crear carpetas
function mkt(){
        mkdir {nmap,content,exploits}
}

function dockerClean() {
  BOLD='\033[1m'
  RESET='\033[0m'
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  BLUE='\033[0;34m'
  RED='\033[0;31m'
  CYAN='\033[0;36m'

  clear

  ejecutar_comando() {
    echo -e "${CYAN}${BOLD}Ejecutando:${RESET} $1"
    if eval "$1" &>/dev/null; then
      echo -e "${GREEN}[✓] $2${RESET}"
    else
      if [[ "$3" == "ignore" ]]; then
        echo -e "${YELLOW}[!] No hay elementos para $2${RESET}"
      else
        echo -e "${RED}[✗] Error al ejecutar: $1${RESET}"
        echo -e "${YELLOW}   Detalles del error:${RESET}"
        eval "$1" 2>&1 | sed 's/^/   /'
      fi
    fi
  }

  # Verificar si Docker está en ejecución
  if ! docker info &>/dev/null; then
    echo -e "${RED}${BOLD}Error: Docker no está en ejecución o no tienes permisos suficientes.${RESET}"
    echo -e "${YELLOW}Por favor, asegúrate de que Docker esté en ejecución y que tengas los permisos necesarios.${RESET}"
    return 1
  fi

  # Cabecera
  echo -e "\n\t\t${BLUE}${BOLD}.:: Limpieza de Docker ::.\n"
  # Eliminar contenedores
  echo -e "${YELLOW}${BOLD}[1/5] Eliminando todos los contenedores...${RESET}"
  ejecutar_comando "sudo docker rm \$(docker ps -a -q) --force" "Contenedores eliminados correctamente." "ignore"
  # Limpiar redes
  echo -e "\n${YELLOW}${BOLD}[2/5] Limpiando redes no utilizadas...${RESET}"
  ejecutar_comando "sudo docker network prune --force" "Redes no utilizadas eliminadas correctamente."
  # Limpiar volúmenes
  echo -e "\n${YELLOW}${BOLD}[3/5] Limpiando volúmenes no utilizados...${RESET}"
  ejecutar_comando "sudo docker volume prune --force" "Volúmenes no utilizados eliminados correctamente."
  # Eliminar imágenes
  echo -e "\n${YELLOW}${BOLD}[4/5] Eliminando todas las imágenes...${RESET}"
  ejecutar_comando "sudo docker rmi \$(docker images -q) --force" "Imágenes eliminadas correctamente." "ignore"
  # Eliminar imágenes huérfanas
  echo -e "\n${YELLOW}${BOLD}[5/5] Eliminando imágenes huérfanas...${RESET}"
  ejecutar_comando "sudo docker images -q --filter \"dangling=true\" | xargs -r docker rmi --force" "Imágenes huérfanas eliminadas correctamente." "ignore"
  # Pie de página
  echo -e "\n${BLUE}${BOLD}\t   .:: Limpieza de Docker completada. ::.${RESET}"
}
# Borrado seguro de archivos
function rmk(){
        scrub -p dod $1
        shred -zun 10 -v $1
}

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ $KEYMAP == vicmd ]] || [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ $KEYMAP == main ]] || [[ $KEYMAP == viins ]] || [[ $KEYMAP = '' ]] || [[ $1 = 'beam' ]]; then
    echo -ne '\e[3 q'
  fi
}
zle -N zle-keymap-select

# Start with beam shape cursor on zsh startup and after every command.
zle-line-init() { zle-keymap-select 'beam'}
# enable auto-suggestions based on the history
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    # change suggestion color
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#363636'
fi


# Función para configurar IP y URL
function setup_target() {
  # Definir colores y estilos
  BOLD='\033[1m'
  RESET='\033[0m'
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  BLUE='\033[0;34m'
  RED='\033[0;31m'
  CYAN='\033[0;36m'

    if [ -z "$1" ]; then
        echo -e "${YELLOW}${BOLD}[!] ${RESET}Uso: ${CYAN}target ${YELLOW}<dirección_IP_objtivo>${RESET}"
        return 1
    fi

    export IP="$1"
    export URL="http://$1"
    clear
    echo -e "${RESET}"
    echo -e "${BLUE}${BOLD}[+]${RESET} Variables configuradas:"
    echo -e "    ${GREEN}[✓] ${RESET}IP....: $IP"
    echo -e "    ${GREEN}[✓] ${RESET}URL...: $URL"
}
