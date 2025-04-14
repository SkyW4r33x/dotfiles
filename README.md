
![Banner](https://i.imgur.com/CS0EsS3.png)  
*Created by SkyW4r33x*

Este script automatiza la instalación y configuración de SkyW4r33x, un entorno personalizado basado en GNOME para sistemas operativos derivados de Debian, como Kali Linux. Instala extensiones de GNOME, herramientas esenciales, dotfiles, configuraciones de terminal y más, con un estilo inspirado en Kali Linux.

## Características principales
- **Extensiones GNOME**: Instala y configura `Dash to Panel` y `Executor` con ajustes personalizados.
- **Herramientas**: Incluye `zsh`, `neovim` con NvChad, `fzf`, `lsd`, `bat`, `terminator`, `kitty`, entre otros.
- **Dotfiles**: Configura `.zshrc` con aliases y funciones útiles (como `settarget`).
- **Personalización**: Fuentes JetBrainsMono, nuevo fondo de pantalla Kali Galaxy, y atajos de teclado personalizados.

## Requisitos previos

- **Sistema operativo**: Debian/Kali Linux .
- **Entorno gráfico**: GNOME Shell (versión 47 o superior recomendada).
- **Privilegios**: Acceso a `sudo` para instalar paquetes y modificar configuraciones del sistema.

- **Dependencias**:  
  - `git`, `make`, `gettext`, `gnome-shell`, `dconf-cli` (se verifican automáticamente).

## Instalación

1. **Clona o descarga este repositorio**:
 ```bash
   git clone https://github.com/SkyW4r33x/dotfiles.git
   cd dotfiles
   ```

2. **Dale permisos de ejecución al script**:
   ```bash
   chmod +x install.py
   ```

3. **Ejecuta el script**:
   ```bash
   ./install.py
   ```

4. **Sigue las instrucciones en pantalla**:
   - El script verificará los requisitos y mostrará un banner.
   - Durante la instalación, aparecerá un estado dinámico de los paquetes y tareas.
   - Al finalizar, reinicia GNOME Shell (`Alt + F2`, escribe `r` y presiona Enter) o el sistema.

## Funcionalidades instaladas

### Extensiones GNOME
- **Dash to Panel**: Barra personalizada en lugar del dock predeterminado.
- **Executor**: Ejecuta comandos personalizados (configurados con scripts como `target.sh`, `vpnip.sh`, `ethernet.sh`).

### Herramientas
- `zsh`: Shell predeterminada con `.zshrc` personalizado.
- `neovim`: Editor con NvChad preconfigurado.
- `fzf`: Búsqueda avanzada en terminal.
- `lsd` y `bat`: Alternativas mejoradas a `ls` y `cat`.
- `terminator` y `kitty`: Terminales personalizados.
- `flameshot`: Capturas de pantalla interactivas.
- `keepassxc`: Gestor de contraseñas.

### Atajos de teclado del sistema
| Atajo             | Acción            |
|-------------------|-------------------|
| `Super + Enter`   | Abre Terminator   |
| `Print`           | Flameshot GUI     |
| `Super + Shift + F` | Firefox         |
| `Super + Shift + O` | Obsidian        |
| `Super + Shift + B` | Burpsuite       |
| `Super + E`       | Nautilus          |


### Atajos de Kitty
| Atajo                  | Acción                           |
|------------------------|----------------------------------|
| Ctrl + Shift + E       | Nueva ventana (división vertical) |
| Ctrl + Shift + O       | Nueva ventana (división horizontal) |
| Ctrl + Shift + Right   | Reducir ancho de ventana         |
| Ctrl + Shift + Left    | Aumentar ancho de ventana        |
| Ctrl + Shift + Up      | Aumentar altura de ventana       |
| Ctrl + Shift + Down    | Reducir altura de ventana        |
| F1                     | Copiar al portapapeles           |
| F2                     | Pegar desde el portapapeles      |
| Ctrl + Shift + W       | Cerrar ventana                   |
| Ctrl + Shift + Q       | Cerrar pestaña                   |
| Ctrl + Shift + O + Up  | Aumentar opacidad de fondo       |
| Ctrl + Shift + O + Down| Reducir opacidad de fondo        |
| Ctrl + Shift + X       | Cambiar a layout "stack"         |
| Ctrl + Shift + Z       | Cambiar a layout "splits"        |
| Alt + Right            | Ir a ventana derecha             |
| Alt + Left             | Ir a ventana izquierda           |
| Alt + Up               | Ir a ventana superior            |
| Alt + Down             | Ir a ventana inferior            |
| Ctrl + Shift + T       | Nueva pestaña                    |
| Ctrl + I               | Establecer título de pestaña     |
| Ctrl + Shift + Page Up | Siguiente pestaña                |
| Ctrl + Shift + Page Down | Pestaña anterior              |


# Alias Agregados a `.zshrc`

Este archivo contiene alias personalizados añadidos al archivo `.zshrc` para mejorar la productividad en la terminal.

## updateAndClean
**Descripción**: Actualiza el sistema operativo y limpia paquetes innecesarios.  
**Uso**: `updateAndClean`  
**Ejemplo**:
```bash
$ updateAndClean
```

## mkt
**Descripción**: Crea carpetas `nmap`, `content` y `exploits`.  
**Uso**: `mkt`  
**Ejemplo**:
```bash
$ mkt
$ ls
nmap  content  exploits
```

## dockerClean
**Descripción**: Elimina contenedores, imágenes, redes y volúmenes de Docker.  
**Uso**: `dockerClean`  
**Ejemplo**:
```bash
$ dockerClean
```

## rmk
**Descripción**: Borra un archivo de forma segura con sobrescritura.  
**Uso**: `rmk <archivo>`  
**Ejemplo**:
```bash
$ rmk secreto.txt
```

## target
**Descripción**: Configura variables `IP` y `URL` para un objetivo de red.  
**Uso**: `target <dirección_IP>`  
**Ejemplo**:
```bash
$ target 192.168.1.1
```

## TU_USUARIO
**Descripción**: Cambia desde `root` al usuario normal sin el uso de `su`.  
**Uso**: `TU_USUARIO`  
**Ejemplo**:
```bash
# TU_USUARIO
$ whoami
usuario_normal
```
# CTF ALIASES

## vulnhub

**Descripción**: Navega rápidamente a la carpeta de máquinas VulnHub.  
**Uso**: vulnhub  
**Ejemplo**:
```bash
$ vulnhub 
$ pwd  
/root/machines_vuln/vulnhub
```

## HTB

**Descripción**: Navega rápidamente a la carpeta de máquinas Hack The Box.  
**Uso**: HTB  
**Ejemplo**:
```bash
$ HTB 
$ pwd  
/root/machines_vuln/HTB
```

## DKL
**Descripción**: Navega rápidamente a la carpeta de máquinas DockerLabs.  
**Uso**: DKL  
**Ejemplo**:
```bash
$ DKL 
$ pwd  
/root/machines_vuln/DockerLabs
```
## Vista previa

Aquí tienes una idea de cómo se ve el entorno una vez configurado:

### Nuevo fondo de pantalla
![enter image description here](https://i.imgur.com/rTk1fvq.jpeg)
_El nuevo fondo de pantalla kali-galaxy-3840x2160.png ofrece un diseño oscuro y futurista que complementa el estilo general del entorno._

### Escritorio con Dash to Panel y Executor

![Escritorio](https://i.imgur.com/QEkTrN5.jpeg)  
_Barra inferior personalizada con Dash to Panel y comandos dinámicos de Executor mostrando información como IP de VPN y estado de Ethernet._

### Fondo para Navegador

![enter image description here](https://i.imgur.com/rdXbl6m.jpeg)
*Nuevo fondo personalizado para la página de inicio de Firefox.*

### Prompt de Kali Linux
| Estado | Prompt        |
|-------------------|-------------------|
| Exitoso | ![Prompt](https://i.imgur.com/fNuGtBM.png)  |
| Fallido | ![Prompt](https://i.imgur.com/oabJiCu.png)              |

_El nuevo prompt de ZSH personalizado muestra un estilo moderno y funcional. Usa colores turquesa (✔) para comandos exitosos y rojo carmesí (✘) para errores, acompañado de información como el usuario, directorio actual y estado del comando anterior, todo con fuentes JetBrainsMono._

### Nuevo diseño al listar carpetas (con LSD)

_lsd está personalizado para mostrar un diseño estilizado con información del sistema y contenido del directorio, usando bordes, íconos Unicode y colores para resaltar estados y tipos de archivos, todo con fuentes JetBrainsMono. Al usar la función settarget <ip> <nombre> (definida en .zshrc), se actualiza "Máquina Víctima" e "IP Víctima" en el listado, sincronizándose también con la extensión Executor. Además, el texto "L3VIATH4N" o "H4PPY H4CK1NG" cambia dinámicamente en cada listado, alternando entre ambos para un toque visual único._

![lsd](https://i.imgur.com/LJPQ1hf.png)

### Terminator

![Terminator](https://i.imgur.com/keN3dVv.jpeg)  
_Terminal multiplexado con un diseño oscuro, fuentes JetBrainsMono y la capacidad de dividir la pantalla en múltiples paneles. Ideal para multitarea con un estilo inspirado en Kali Linux._

### Kitty

![Kitty](https://i.imgur.com/apgMe29.jpeg)
  
__Terminal ligero con fondo semi-transparente, pestañas powerline y fuentes JetBrainsMono._._

### Neovim con NvChad

![Neovim](https://i.imgur.com/UoqShDn.png)  
_Editor de texto moderno con una interfaz limpia y funcionalidades avanzadas._

# H4PPY H4CK1NG

