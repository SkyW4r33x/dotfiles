#!/usr/bin/env python3

import os
import json
import subprocess
import urllib.request
import zipfile
import tempfile
import sys
import shutil
import time
from pathlib import Path
import logging

class KaliStyle:
    RESET = '\033[0m'
    BOLD = '\033[1m'
    BLUE = '\033[38;2;39;127;255m'  
    TURQUOISE = '\033[38;2;71;212;185m' 
    ORANGE = '\033[38;2;255;138;24m' 
    WHITE = '\033[37m'
    GREY = '\033[38;5;242m'
    RED = '\033[38;2;220;20;60m'  
    GREEN = '\033[38;2;71;212;185m' 
    YELLOW = '\033[0;33m'
    MAGENTA = '\033[0;35m'
    CYAN = '\033[0;36m'
    SUDO_COLOR = '\033[38;2;94;189;171m' 
    APT_COLOR = '\033[38;2;73;174;230m' 
    SUCCESS = f"   {TURQUOISE}✔{RESET}"
    ERROR = f"   {RED}✘{RESET}"
    INFO = f"{BLUE}[i]{RESET}"
    WARNING = "⚠️ "

class CombinedInstaller:
    def __init__(self):
        self.home_dir = str(Path.home())
        self.current_user = os.environ.get('USER') or Path.home().name
        self.extensions_dir = os.path.join(self.home_dir, '.local/share/gnome-shell/extensions')
        self.temp_dir = '/tmp/gnome-extensions-install'
        self.config_dir = os.path.join(self.home_dir, '.config')
        self.script_dir = os.path.dirname(os.path.realpath(__file__))
        self.pictures_dir = os.path.join(self.home_dir, 'Pictures')
        self.actions_taken = []
        self.needs_gdm_restart = False  # Bandera para indicar si se necesita reiniciar GDM
        logging.basicConfig(filename='install.log', level=logging.INFO, 
                          format='%(asctime)s - %(levelname)s - %(message)s')
        self.executor_config_dir = f"/home/{self.current_user}/.config/bin"
        self.executor_id = "executor@raujonas.github.io"
        self.executor_versions = {
            47: {"version": "v27", "url": "https://github.com/raujonas/executor/releases/download/v27/executor@raujonas.github.io"},
            48: {"version": "v28", "url": "https://github.com/raujonas/executor/releases/download/v28/executor@raujonas.github.io"}
        }
        self.executor_right_commands = {
            "commands": [
                {"isActive": True, "command": f"/home/{self.current_user}/.config/bin/bin-gnome/target.sh", "interval": 1, "uuid": "66268560-cea9-4d1e-a877-17a63e474000"},
                {"isActive": True, "command": "echo '    '", "interval": 1, "uuid": "c47c221b-3011-49c5-a1f3-765b0ddfdd48"},
                {"isActive": True, "command": f"/home/{self.current_user}/.config/bin/bin-gnome/vpnip.sh", "interval": 1, "uuid": "44275a45-c74d-43da-8f80-2a31e7ced1fb"},
                {"isActive": True, "command": "echo '    '", "interval": 1, "uuid": "398bf1a0-4f5c-43f5-a022-a440698afc23"},
                {"isActive": True, "command": f"/home/{self.current_user}/.config/bin/bin-gnome/ethernet.sh", "interval": 1, "uuid": "a3407daf-6c76-4fa5-9742-5f48c085fb3b"}
            ]
        }
        self.executor_dconf_settings = f"""[/]
center-active=false
center-commands-json='{{\\"commands\\":[]}}'
click-on-output-active=false
left-active=false
left-commands-json='{{\\"commands\\":[]}}'
location=2
right-active=true
right-commands-json='{json.dumps(self.executor_right_commands).replace("'", "\\'")}'
right-index=1
"""

    def show_banner(self):
        print(f"{KaliStyle.BLUE}{KaliStyle.BOLD}")
        print("""
██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝""")
        print(f"{KaliStyle.WHITE}\t\t [ Dotfiles GNOME - v.1.1 ]{KaliStyle.RESET}")
        print(f"{KaliStyle.GREY}\t\t  [ Created by SkyW4r33x ]{KaliStyle.RESET}\n")

    def run_command(self, command, shell=False, sudo=False, quiet=True):
        try:
            if sudo and not shell:
                command = ['sudo'] + command
            result = subprocess.run(
                command,
                shell=shell,
                check=True,
                stdout=subprocess.PIPE if quiet else None,
                stderr=subprocess.PIPE if quiet else None,
                text=True
            )
            return True
        except subprocess.CalledProcessError as e:
            if not quiet:
                print(f"{KaliStyle.ERROR} Error ejecutando comando: {command}")
                print(f"Salida: {e.stdout}")
                print(f"Error: {e.stderr}")
            logging.error(f"Error ejecutando comando: {command} - {e}\nSalida: {e.stdout}\nError: {e.stderr}")
            return False
        except PermissionError:
            print(f"{KaliStyle.ERROR} Permisos insuficientes para ejecutar: {command}")
            return False

    def check_command(self, command):
        try:
            subprocess.run([command, "--version"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            return True
        except FileNotFoundError:
            return False

    def check_os(self):
        if not os.path.exists('/etc/debian_version'):
            print(f"{KaliStyle.ERROR} Este script está diseñado para sistemas basados en Debian/Kali")
            return False
        return True

    def check_sudo_privileges(self):
        try:
            result = subprocess.run(['sudo', '-n', 'true'], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            if result.returncode == 0:
                return True
            else:
                print(f"{KaliStyle.WARNING} Este script necesita ejecutar comandos con sudo.")
                return True
        except Exception as e:
            print(f"{KaliStyle.ERROR} No se pudieron verificar los privilegios de sudo: {str(e)}")
            return False

    def check_required_files(self):
        required_files = [
            "dash-to-panel-settings.dconf", "nvim-linux64.tar.gz", "JetBrainsMono.zip",
            "extractPorts.py", ".zshrc", "terminator", "kitty", "sudo-plugin",
            "wallpaper/kali-galaxy-3840x2160.png", "wallpaper/browser-home-page-banner.jpg"
        ]
        missing = [f for f in required_files if not os.path.exists(os.path.join(self.script_dir, f))]
        if missing:
            print(f"{KaliStyle.ERROR} Faltan archivos requeridos: {', '.join(missing)}")
            print(f"{KaliStyle.INFO} Asegúrate de que estén en {self.script_dir}")
            return False
        return True

    def check_graphical_environment(self):
        if not os.environ.get('DISPLAY'):
            print(f"{KaliStyle.ERROR} No se detectó un entorno gráfico.")
            return False
        return True

    def check_gnome_requirements(self):
        print(f"{KaliStyle.INFO} Verificando requisitos para extensiones GNOME...")
        requirements = {
            'git': {'pkg': 'git', 'desc': 'Git'},
            'make': {'pkg': 'make', 'desc': 'Make'},
            'msgfmt': {'pkg': 'gettext', 'desc': 'Gettext'},
            'gnome-extensions': {'pkg': 'gnome-shell', 'desc': 'GNOME Extensions CLI'},
            'dconf': {'pkg': 'dconf-cli', 'desc': 'Dconf CLI'}
        }
        
        missing_pkgs = []
        for command, info in requirements.items():
            if not self.check_command(command):
                missing_pkgs.append(info['pkg'])
                print(f"{KaliStyle.ERROR} Falta {command} ({info['desc']})")
            else:
                print(f"{KaliStyle.SUCCESS} Encontrado {command}")

        if missing_pkgs:
            print(f"\n{KaliStyle.INFO} Instale manualmente:\n   {KaliStyle.BLUE}→{KaliStyle.RESET} {KaliStyle.SUDO_COLOR}sudo {KaliStyle.APT_COLOR}apt {KaliStyle.RESET}install {' '.join(missing_pkgs)}{KaliStyle.SUDO_COLOR} -y{KaliStyle.RESET}")
            return False
        print(f"{KaliStyle.SUCCESS} Requisitos verificados")
        return True

    def install_additional_packages(self):
        print(f"\n{KaliStyle.INFO} Instalación de herramientas")
        self.packages = [
            'xclip', 'zsh', 'neovim', 'lsd', 'bat', 'terminator', 'kitty',
            'keepassxc', 'gnome-shell-extensions', 'flameshot'
        ]
        self.max_length = max(len(pkg) for pkg in self.packages)
        self.state_length = 12
        self.states = {pkg: f"{KaliStyle.GREY}Pendiente{KaliStyle.RESET}" for pkg in self.packages}
        
        def print_status(first_run=False):
            if not first_run:
                print(f"\033[{len(self.packages) + 1}A", end="")
            
            print(f"{KaliStyle.INFO} Instalando paquetes:")
            for pkg, state in self.states.items():
                print(f"\033[K", end="")
                print(f"  {KaliStyle.YELLOW}•{KaliStyle.RESET} {pkg:<{self.max_length}} {state:<{self.state_length}}")
            sys.stdout.flush()

        try:
            print(f"{KaliStyle.INFO} Actualizando repositorios...")
            if not self.run_command(['apt', 'update'], sudo=True, quiet=True):
                print(f"{KaliStyle.ERROR} Error al actualizar repositorios")
                return False
            print(f"{KaliStyle.SUCCESS} Repositorios actualizados")

            print_status(first_run=True)
            failed_packages = []
            for pkg in self.packages:
                self.states[pkg] = f"{KaliStyle.YELLOW}Instalando...{KaliStyle.RESET}"
                print_status()
                try:
                    if self.run_command(['apt', 'install', '-y', pkg], sudo=True, quiet=True):
                        self.states[pkg] = f"{KaliStyle.GREEN}Completado{KaliStyle.RESET}"
                    else:
                        self.states[pkg] = f"{KaliStyle.RED}Fallido{KaliStyle.RESET}"
                        failed_packages.append(pkg)
                        print(f"{KaliStyle.WARNING} Advertencia: Falló la instalación de {pkg}, continuando...")
                except subprocess.CalledProcessError as e:
                    self.states[pkg] = f"{KaliStyle.RED}Fallido{KaliStyle.RESET}"
                    failed_packages.append(pkg)
                    logging.error(f"Error instalando {pkg}: {e}\nSalida: {e.stdout}\nError: {e.stderr}")
                    print(f"{KaliStyle.WARNING} Advertencia: Falló la instalación de {pkg}, continuando...")
                print_status()
                time.sleep(0.2)
            
            if failed_packages:
                print(f"\n{KaliStyle.WARNING} Los siguientes paquetes fallaron: {', '.join(failed_packages)}")
                print(f"{KaliStyle.INFO} Revisa install.log para más detalles.")
            else:
                print(f"\n{KaliStyle.SUCCESS} Instalación finalizada")
            return True
        except Exception as e:
            print(f"\n{KaliStyle.ERROR} Error instalando paquetes: {str(e)}")
            logging.error(f"Error general en install_additional_packages: {str(e)}")
            return False

    def copy_executor_bin_folder(self):
        try:
            bin_source = os.path.join(self.script_dir, "bin")
            if not os.path.exists(bin_source):
                print(f"{KaliStyle.WARNING} No se encontró 'bin' en {self.script_dir}")
                return False

            bin_gnome_dir = os.path.join(bin_source, "bin-gnome")
            required_scripts = ["target.sh", "vpnip.sh", "ethernet.sh"]
            missing_scripts = [s for s in required_scripts if not os.path.exists(os.path.join(bin_gnome_dir, s))]
            if missing_scripts:
                print(f"{KaliStyle.ERROR} Faltan scripts: {', '.join(missing_scripts)}")
                return False

            if os.path.exists(self.executor_config_dir):
                shutil.rmtree(self.executor_config_dir)
            shutil.copytree(bin_source, self.executor_config_dir)

            for root, _, files in os.walk(self.executor_config_dir):
                for file in files:
                    if file.endswith(".sh"):
                        os.chmod(os.path.join(root, file), 0o755)
            print(f"{KaliStyle.SUCCESS} Carpeta 'bin' copiada y permisos otorgados")
            return True
        except Exception as e:
            print(f"{KaliStyle.ERROR} Error al copiar 'bin': {e}")
            return False

    def get_gnome_version(self):
        try:
            result = subprocess.run(["gnome-shell", "--version"], capture_output=True, text=True, check=True)
            return int(result.stdout.strip().split()[-1].split('.')[0])
        except Exception as e:
            print(f"{KaliStyle.ERROR} Error al verificar GNOME Shell: {e}")
            sys.exit(1)

    def select_executor_version(self, gnome_version):
        if gnome_version >= 48:
            return self.executor_versions[48]["url"], self.executor_versions[48]["version"]
        elif gnome_version == 47:
            return self.executor_versions[47]["url"], self.executor_versions[47]["version"]
        else:
            print(f"{KaliStyle.ERROR} GNOME Shell {gnome_version} no compatible con Executor")
            sys.exit(1)

    def download_and_install_executor(self):
        print(f"\n{KaliStyle.INFO} Instalando Executor...")
        try:
            gnome_version = self.get_gnome_version()
            extension_url, executor_version = self.select_executor_version(gnome_version)
            with tempfile.NamedTemporaryFile(suffix=".zip", delete=False) as temp_file:
                urllib.request.urlretrieve(extension_url, temp_file.name)
                with zipfile.ZipFile(temp_file.name, 'r') as zip_ref:
                    zip_ref.extractall(os.path.join(self.extensions_dir, self.executor_id))
            os.remove(temp_file.name)
            print(f"{KaliStyle.SUCCESS} Executor {executor_version} instalado")
            return True
        except Exception as e:
            print(f"{KaliStyle.ERROR} Error instalando Executor: {e}")
            return False

    def enable_executor(self):
        print(f"\n{KaliStyle.INFO} Activando Executor...")
        try:
            subprocess.run(['gnome-extensions', 'enable', self.executor_id], check=True, stdout=subprocess.DEVNULL)
            print(f"{KaliStyle.SUCCESS} {self.executor_id} activada")
            return True
        except Exception as e:
            print(f"{KaliStyle.ERROR} Error activando Executor: {e}")
            return False

    def export_executor_dconf_settings(self):
        try:
            dconf_file = os.path.join(self.script_dir, "executor-settings.dconf")
            with open(dconf_file, "w") as f:
                f.write(self.executor_dconf_settings)
            return dconf_file
        except Exception as e:
            print(f"{KaliStyle.ERROR} Error exportando configuraciones: {e}")
            return None

    def import_executor_dconf_settings(self, dconf_file):
        try:
            subprocess.run(["dconf", "load", "/org/gnome/shell/extensions/executor/"], 
                           stdin=open(dconf_file, "r"), check=True)
            print(f"{KaliStyle.SUCCESS} Configuraciones de Executor importadas")
            return True
        except Exception as e:
            print(f"{KaliStyle.ERROR} Error importando configuraciones: {e}")
            return False

    def install_gnome_extensions(self):
        print(f"\n{KaliStyle.INFO} Instalando extensiones GNOME...")
        if os.path.exists(self.temp_dir):
            shutil.rmtree(self.temp_dir)
        os.makedirs(self.temp_dir)
        os.chdir(self.temp_dir)

        if not self.copy_executor_bin_folder() or not self.install_dash_to_panel() or not self.download_and_install_executor():
            return False
        self.manage_extensions(quiet=True)
        return True

    def install_dash_to_panel(self):
        print(f"\n{KaliStyle.INFO} Instalando Dash to Panel...")
        try:
            if os.path.exists("dash-to-panel"):
                shutil.rmtree("dash-to-panel")
            
            result = subprocess.run(
                ["git", "clone", "--depth", "1", "https://github.com/home-sweet-gnome/dash-to-panel.git"],
                capture_output=True, text=True, check=True
            )
            if not os.path.exists("dash-to-panel"):
                print(f"{KaliStyle.ERROR} El directorio 'dash-to-panel' no se creó después de git clone")
                print(f"Salida: {result.stdout}")
                print(f"Error: {result.stderr}")
                return False
            
            os.chdir("dash-to-panel")
            if not self.run_command(["make", "install"], quiet=True):
                print(f"{KaliStyle.ERROR} Error ejecutando 'make install' para Dash to Panel")
                return False
            
            ext_paths = [
                os.path.join(self.extensions_dir, "dash-to-panel@jderose9.github.com"),
                "/usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com"
            ]
            if not any(os.path.exists(path) for path in ext_paths):
                print(f"{KaliStyle.ERROR} Dash to Panel no encontrado después de la instalación")
                return False
            
            print(f"{KaliStyle.SUCCESS} Dash to Panel instalado")
            return True
        except subprocess.CalledProcessError as e:
            print(f"{KaliStyle.ERROR} Error clonando el repositorio de Dash to Panel: {e}")
            print(f"Salida: {e.stdout}")
            print(f"Error: {e.stderr}")
            return False
        except Exception as e:
            print(f"{KaliStyle.ERROR} Error instalando Dash to Panel: {e}")
            return False
        finally:
            os.chdir(self.temp_dir)

    def manage_extensions(self, quiet=False):
        if not quiet:
            print(f"\n{KaliStyle.INFO} Verificando y desactivando extensiones existentes")
        try:
            extensions_to_disable = [
                'dash-to-dock@micxgx.gmail.com', 
                'system-monitor@gnome-shell-extensions.gcampax.github.com',
                'apps-menu@gnome-shell-extensions.gcampax.github.com'
            ]
            for ext in extensions_to_disable:
                subprocess.run(['gnome-extensions', 'disable', ext], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
                if not quiet:
                    print(f"{KaliStyle.SUCCESS} Extensión {ext} desactivada (si estaba activa)")
        except Exception:
            if not quiet:
                print(f"{KaliStyle.WARNING} No se pudieron gestionar todas las extensiones")

    def enable_extensions(self):
        print(f"\n{KaliStyle.INFO} Activando extensiones...")
        extensions = ["dash-to-panel@jderose9.github.com", "executor@raujonas.github.io"]
        for ext in extensions:
            try:
                subprocess.run(['gnome-extensions', 'enable', ext], check=True, stdout=subprocess.DEVNULL)
                print(f"{KaliStyle.SUCCESS} {ext} activada")
            except Exception:
                print(f"{KaliStyle.ERROR} Error activando {ext}")

        dash_config_source = os.path.join(self.script_dir, "dash-to-panel-settings.dconf")
        if os.path.exists(dash_config_source) and os.path.getsize(dash_config_source) > 0:
            with open(dash_config_source, 'rb') as f:
                subprocess.run(['dconf', 'load', '/org/gnome/shell/extensions/dash-to-panel/'], input=f.read(), check=True)
            print(f"{KaliStyle.SUCCESS} Configuración de Dash to Panel aplicada")
        
        dconf_file = self.export_executor_dconf_settings()
        if dconf_file:
            self.import_executor_dconf_settings(dconf_file)

    def verify_installation(self):
        print(f"\n{KaliStyle.INFO} Verificando instalación...")
        extensions_to_check = ["dash-to-panel@jderose9.github.com", "executor@raujonas.github.io"]
        installed_count = 0
        for ext in extensions_to_check:
            ext_path = os.path.join(self.extensions_dir, ext)
            system_path = f"/usr/share/gnome-shell/extensions/{ext}"
            if os.path.exists(ext_path) or os.path.exists(system_path):
                print(f"{KaliStyle.SUCCESS} {ext} encontrada")
                installed_count += 1
            else:
                print(f"{KaliStyle.ERROR} No se encontró {ext}")
        
        if installed_count > 0:
            print(f"\n{KaliStyle.WARNING} Reinicie GNOME Shell (Alt + F2, 'r')")
            input(f"{KaliStyle.SUDO_COLOR}Presione Enter tras reiniciar GNOME Shell...{KaliStyle.RESET}")
            self.enable_extensions()
            return True
        return False

    def setup_dotfiles(self):
        print(f"\n{KaliStyle.INFO} Configurando dotfiles...")
        success = True
        zshrc_path = os.path.join(self.home_dir, '.zshrc')
        if os.path.exists(zshrc_path):
            backup_path = f"{zshrc_path}.backup.{time.strftime('%Y%m%d_%H%M%S')}"
            shutil.copy2(zshrc_path, backup_path)
            self.actions_taken.append({'type': 'file_copy', 'dest': backup_path})
            print(f"{KaliStyle.SUCCESS} Backup de .zshrc creado")

        required_files = {'.zshrc': os.path.join(self.script_dir, ".zshrc")}
        for name, path in required_files.items():
            if not os.path.exists(path):
                print(f"{KaliStyle.ERROR} No se encontró {name}")
                success = False
        
        if success:
            shutil.copy2(required_files['.zshrc'], self.home_dir)
            self.actions_taken.append({'type': 'file_copy', 'dest': zshrc_path})
            self.install_fzf(self.current_user)
            self.install_fzf("root")
            subprocess.run(['sudo', 'ln', '-sf', zshrc_path, "/root/.zshrc"], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            self.install_neovim()
            print(f"{KaliStyle.SUCCESS} Dotfiles configurados")
        return success

    def install_fzf(self, user):
        home_dir = f"/home/{user}" if user != "root" else "/root"
        fzf_dir = os.path.join(home_dir, ".fzf")
        if not os.path.exists(fzf_dir):
            print(f"{KaliStyle.INFO} Instalando fzf para {user}...")
            cmd = ["sudo"] if user == "root" else []
            subprocess.run(cmd + ["git", "clone", "--depth", "1", "https://github.com/junegunn/fzf.git", fzf_dir], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            subprocess.run(cmd + [f"{fzf_dir}/install", "--all"], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            print(f"{KaliStyle.SUCCESS} fzf instalado para {user}")

    def install_neovim(self):
        print(f"\n{KaliStyle.INFO} Instalando Neovim y NvChad...")
        nvim_archive = os.path.join(self.script_dir, "nvim-linux64.tar.gz")
        if os.path.exists(nvim_archive):
            subprocess.run(["sudo", "cp", nvim_archive, "/opt/"], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            subprocess.run(["sudo", "tar", "xzf", "/opt/nvim-linux64.tar.gz", "-C", "/opt/"], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            nvim_config = os.path.join(self.config_dir, "nvim")
            if os.path.exists(nvim_config):
                shutil.move(nvim_config, f"{nvim_config}.bak")
            subprocess.run(["git", "clone", "https://github.com/NvChad/starter", nvim_config], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            subprocess.run(["sudo", "git", "clone", "https://github.com/NvChad/starter", "/root/.config/nvim"], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            print(f"{KaliStyle.SUCCESS} Neovim y NvChad instalados")

    def install_extract_ports(self):
        print(f"\n{KaliStyle.INFO} Instalando extractPorts...")
        extractports_path = os.path.join(self.script_dir, "extractPorts.py")
        if os.path.exists(extractports_path):
            subprocess.run(["chmod", "+x", extractports_path], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            subprocess.run(["sudo", "cp", extractports_path, "/usr/bin/extractPorts.py"], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            subprocess.run(["sudo", "chmod", "+x", "/usr/bin/extractPorts.py"], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            print(f"{KaliStyle.SUCCESS} extractPorts instalado")
            return True
        return False

    def setup_aliases(self):
        print(f"\n{KaliStyle.INFO} Configurando aliases...")
        zshrc_path = f"/home/{self.current_user}/.zshrc"
        aliases_and_functions = [
            f"\n# Aliases\nalias {self.current_user}='su {self.current_user}'",
            f"\n# settargeted\nsettarget () {{\n\tip_address=$1\n\tmachine_name=$2\n\techo \"$ip_address $machine_name\" > \"/home/{self.current_user}/.config/bin/target/target.txt\"\n}}"
        ]
        with open(zshrc_path, 'a') as f:
            f.writelines(aliases_and_functions)
        print(f"{KaliStyle.SUCCESS} Aliases configurados")
        return True

    def install_fonts(self):
        print(f"\n{KaliStyle.INFO} Instalando fuentes JetBrainsMono...")
        fonts_archive = os.path.join(self.script_dir, "JetBrainsMono.zip")
        if os.path.exists(fonts_archive):
            subprocess.run(["sudo", "mkdir", "-p", "/usr/share/fonts/JetBrainsMono"], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            subprocess.run(["sudo", "unzip", "-o", fonts_archive, "-d", "/usr/share/fonts/JetBrainsMono/"], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            subprocess.run(["sudo", "fc-cache", "-f", "-v"], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            print(f"{KaliStyle.SUCCESS} Fuentes instaladas")
            return True
        return False

    def install_sudo_plugin(self):
        print(f"\n{KaliStyle.INFO} Instalando plugin de sudo...")
        sudo_plugin_dir = os.path.join(self.script_dir, "sudo-plugin")
        if os.path.exists(sudo_plugin_dir):
            subprocess.run(["sudo", "mkdir", "-p", "/usr/share/sudo-plugin"], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            subprocess.run(["sudo", "cp", "-r", f"{sudo_plugin_dir}/.", "/usr/share/sudo-plugin/"], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            subprocess.run(["sudo", "chown", "-R", f"{self.current_user}:{self.current_user}", "/usr/share/sudo-plugin"], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            print(f"{KaliStyle.SUCCESS} Plugin de sudo instalado")
            return True
        return False

    def install_config_folder(self, source_dir, dest_dir, config_name):
        print(f"\n{KaliStyle.INFO} Instalando configuración de {config_name}...")
        os.makedirs(dest_dir, exist_ok=True)
        if os.path.exists(source_dir):
            if os.path.exists(dest_dir):
                shutil.rmtree(dest_dir)
            shutil.copytree(source_dir, dest_dir)
            self.actions_taken.append({'type': 'dir_copy', 'dest': dest_dir})
            print(f"{KaliStyle.SUCCESS} Configuración de {config_name} instalada")
            return True
        return False

    def install_terminator_config(self):
        return self.install_config_folder(
            os.path.join(self.script_dir, "terminator"),
            os.path.join(self.home_dir, '.config', 'terminator'),
            "Terminator"
        )

    def install_kitty_config(self):
        return self.install_config_folder(
            os.path.join(self.script_dir, "kitty"),
            os.path.join(self.home_dir, '.config', 'kitty'),
            "Kitty"
        )

    def setup_wallpaper(self):
        print(f"\n{KaliStyle.INFO} Configurando fondo de pantalla...")
        wallpaper_source_dir = os.path.join(self.script_dir, "wallpaper")
        wallpaper_file = os.path.join(wallpaper_source_dir, "kali-galaxy-3840x2160.png")
        wallpaper_dest_dir = os.path.join(self.pictures_dir, "wallpaper")
        wallpaper_dest_path = os.path.join(wallpaper_dest_dir, "kali-galaxy-3840x2160.png")

        try:
            if not os.path.exists(wallpaper_file):
                print(f"{KaliStyle.ERROR} No se encontró el fondo de pantalla en {wallpaper_file}")
                return False

            os.makedirs(wallpaper_dest_dir, exist_ok=True)

            shutil.copy2(wallpaper_file, wallpaper_dest_path)
            self.actions_taken.append({'type': 'file_copy', 'dest': wallpaper_dest_path})

            subprocess.run(['gsettings', 'set', 'org.gnome.desktop.background', 'picture-uri', f"file://{wallpaper_dest_path}"], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            subprocess.run(['gsettings', 'set', 'org.gnome.desktop.background', 'picture-uri-dark', f"file://{wallpaper_dest_path}"], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            subprocess.run(['gsettings', 'set', 'org.gnome.desktop.background', 'picture-options', 'zoom'], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            print(f"{KaliStyle.SUCCESS} Fondo de pantalla establecido")
            return True
        except Exception as e:
            print(f"{KaliStyle.ERROR} Error al configurar el fondo de pantalla: {str(e)}")
            return False

    def setup_gdm_wallpaper(self):
        print(f"\n{KaliStyle.INFO} Configurando fondo de pantalla para GDM...")
        wallpaper_source_dir = os.path.join(self.script_dir, "wallpaper")
        wallpaper_source_file = os.path.join(wallpaper_source_dir, "gdm_wallpaper.png")
        gdm_wallpaper_dest_dir = "/usr/share/backgrounds/kali"
        gdm_wallpaper_dest_file = os.path.join(gdm_wallpaper_dest_dir, "login-blurred")
        backup_file = f"{gdm_wallpaper_dest_file}.bak.{time.strftime('%Y%m%d_%H%M%S')}"

        try:
            if not os.path.exists(wallpaper_source_file):
                print(f"{KaliStyle.ERROR} No se encontró el fondo de pantalla en {wallpaper_source_file}")
                return False
            print(f"{KaliStyle.SUCCESS} Archivo de fondo encontrado: {wallpaper_source_file}")

            if not os.path.exists(gdm_wallpaper_dest_dir):
                if not self.run_command(['mkdir', '-p', gdm_wallpaper_dest_dir], sudo=True, quiet=True):
                    print(f"{KaliStyle.ERROR} No se pudo crear el directorio {gdm_wallpaper_dest_dir}")
                    return False
                print(f"{KaliStyle.SUCCESS} Directorio creado: {gdm_wallpaper_dest_dir}")

            if os.path.exists(gdm_wallpaper_dest_file):
                if not self.run_command(['cp', gdm_wallpaper_dest_file, backup_file], sudo=True, quiet=True):
                    print(f"{KaliStyle.ERROR} No se pudo crear respaldo de {gdm_wallpaper_dest_file}")
                    return False
                self.actions_taken.append({'type': 'file_copy', 'dest': backup_file})
                print(f"{KaliStyle.SUCCESS} Respaldo creado: {backup_file}")

            if not self.run_command(['cp', wallpaper_source_file, gdm_wallpaper_dest_file], sudo=True, quiet=True):
                print(f"{KaliStyle.ERROR} No se pudo copiar el fondo a {gdm_wallpaper_dest_file}")
                return False
            if not self.run_command(['chmod', '644', gdm_wallpaper_dest_file], sudo=True, quiet=True):
                print(f"{KaliStyle.ERROR} No se pudo establecer permisos en {gdm_wallpaper_dest_file}")
                return False
            self.actions_taken.append({'type': 'file_copy', 'dest': gdm_wallpaper_dest_file})
            print(f"{KaliStyle.SUCCESS} Fondo copiado y renombrado a {gdm_wallpaper_dest_file}")

            self.needs_gdm_restart = True

            print(f"{KaliStyle.SUCCESS} Fondo de pantalla de GDM configurado")
            return True
        except Exception as e:
            print(f"{KaliStyle.ERROR} Error al configurar el fondo de pantalla de GDM: {str(e)}")
            return False

    def setup_browser_wallpaper(self):
        print(f"\n{KaliStyle.INFO} Configurando fondo de pantalla del navegador...")
        wallpaper_source_dir = os.path.join(self.script_dir, "wallpaper")
        wallpaper_file = os.path.join(wallpaper_source_dir, "browser-home-page-banner.jpg")
        target_dir = "/usr/share/kali-defaults/web/images"
        target_file = os.path.join(target_dir, "browser-home-page-banner.jpg")
        backup_file = os.path.join(target_dir, "browser-home-page-banner.jpg.bak")

        try:
            if not os.path.exists(wallpaper_file):
                print(f"{KaliStyle.ERROR} No se encontró el fondo del navegador en {wallpaper_file}")
                return False

            os.makedirs(target_dir, exist_ok=True)

            if os.path.exists(target_file):
                self.run_command(['mv', target_file, backup_file], sudo=True, quiet=True)
                self.actions_taken.append({'type': 'file_copy', 'dest': backup_file})

            self.run_command(['cp', wallpaper_file, target_file], sudo=True, quiet=True)
            self.actions_taken.append({'type': 'file_copy', 'dest': target_file})

            self.run_command(['chmod', '644', target_file], sudo=True, quiet=True)
            print(f"{KaliStyle.SUCCESS} Fondo de pantalla del navegador configurado correctamente.")
            return True
        except Exception as e:
            print(f"{KaliStyle.ERROR} Error al configurar el fondo del navegador: {str(e)}")
            return False

    def setup_ctf_folders(self):
        print(f"\n{KaliStyle.INFO} Configurando carpetas para CTF...")
        ctf_folders = [
            "/root/machines_vuln/HTB",
            "/root/machines_vuln/Vulnhub",
            "/root/machines_vuln/DockerLabs"
        ]

        try:
            for folder in ctf_folders:
                if not os.path.exists(folder):
                    self.run_command(['mkdir', '-p', folder], sudo=True, quiet=True)
                    self.actions_taken.append({'type': 'dir_copy', 'dest': folder})
                    print(f"{KaliStyle.SUCCESS} Creada carpeta {folder}")
                else:
                    print(f"{KaliStyle.WARNING} La carpeta {folder} ya existe")
            print(f"\n{KaliStyle.SUCCESS} Carpetas CTF configuradas")
            return True
        except Exception as e:
            print(f"{KaliStyle.ERROR} Error al crear carpetas CTF: {str(e)}")
            return False

    def configure_keyboard_shortcuts(self):
        print(f"\n{KaliStyle.INFO} Configurando atajos de teclado...")
        default_keys = ['screenshot', 'screenshot-clip', 'window-screenshot', 'window-screenshot-clip', 'area-screenshot', 'area-screenshot-clip']
        shell_keys = ['screenshot', 'screenshot-window', 'show-screenshot-ui']
        
        for key in default_keys + shell_keys:
            schema = 'org.gnome.settings-daemon.plugins.media-keys' if key in default_keys else 'org.gnome.shell.keybindings'
            subprocess.run(['gsettings', 'set', schema, key, '[]'], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

        shortcuts = [
            {"nombre": "Terminator", "comando": "/usr/bin/terminator", "atajo": "<Super>Return"},
            {"nombre": "Obsidian", "comando": "/usr/bin/obsidian", "atajo": "<Super><Shift>o"},
            {"nombre": "Captura de Pantalla", "comando": "flameshot gui", "atajo": "Print"},
            {"nombre": "Burpsuite", "comando": "/usr/bin/burpsuite", "atajo": "<Super><Shift>b"},
            {"nombre": "Firefox", "comando": "/usr/bin/firefox", "atajo": "<Super><Shift>f"},
            {"nombre": "Nautilus", "comando": "/usr/bin/nautilus", "atajo": "<Super>e"}
        ]

        rutas = [f"'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom{i}/'" for i in range(len(shortcuts))]
        subprocess.run(['gsettings', 'set', 'org.gnome.settings-daemon.plugins.media-keys', 'custom-keybindings', f"[{', '.join(rutas)}]"], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        for i, shortcut in enumerate(shortcuts):
            base_path = f"org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom{i}/"
            subprocess.run(['gsettings', 'set', base_path, 'name', shortcut['nombre']], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            subprocess.run(['gsettings', 'set', base_path, 'command', shortcut['comando']], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            subprocess.run(['gsettings', 'set', base_path, 'binding', shortcut['atajo']], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            print(f"{KaliStyle.SUCCESS} Atajo configurado: {shortcut['nombre']}")
        return True

    def show_final_message(self):
        print(f"\n{KaliStyle.GREEN}{KaliStyle.BOLD}╔════════════════════════════════════╗")
        print(f"║ Instalación Completada Exitosamente║")
        print(f"╚════════════════════════════════════╝{KaliStyle.RESET}\n")
        
        sections = [
            ("Atajos de Teclado", [
                ("Terminator", "Super + Enter"),
                ("Flameshot", "Print"),
                ("Firefox", "Super + Shift + F"),
                ("Obsidian", "Super + Shift + O"),
                ("Burpsuite", "Super + Shift + B"),
                ("Nautilus", "Super + E")
            ]),
            ("Herramientas", [
                ("Neovim", "Editor principal"),
                ("ZSH", "Shell personalizada"),
                ("FZF", "Búsqueda avanzada"),
                ("LSD", "Listado mejorado"),
                ("BAT", "Visualizador mejorado"),
                ("Terminator", "Terminal multiplexor")
            ]),
            ("Extensiones GNOME", [
                ("Dash to Panel", "Panel personalizado"),
                ("Executor", "Comandos personalizados")
            ])
        ]
        
        for title, items in sections:
            print(f"{KaliStyle.BLUE}» {title}{KaliStyle.RESET}")
            print(f"{KaliStyle.GREY}{'─' * 40}{KaliStyle.RESET}")
            for name, desc in items:
                print(f"  {KaliStyle.YELLOW}• {name:<15}{KaliStyle.WHITE}{desc}")
            print()
        
        print(f"{KaliStyle.WARNING} Nota: Reinicie GNOME (Alt+F2, 'r') o el sistema para aplicar todos los cambios.")

    def cleanup(self):
        print(f"\n{KaliStyle.INFO} Limpiando archivos temporales...")
        if os.path.exists(self.temp_dir):
            shutil.rmtree(self.temp_dir)
            print(f"{KaliStyle.SUCCESS} {KaliStyle.GREEN}Completado{KaliStyle.RESET}")
            return True
        return True

    def rollback(self):
        print(f"{KaliStyle.WARNING} Revirtiendo cambios...")
        for action in reversed(self.actions_taken):
            if action['type'] == 'file_copy' and os.path.exists(action['dest']):
                self.run_command(['rm', action['dest']], sudo=True, quiet=True)
                print(f"{KaliStyle.SUCCESS} Eliminado {action['dest']}")
            elif action['type'] == 'dir_copy' and os.path.exists(action['dest']):
                self.run_command(['rm', '-rf', action['dest']], sudo=True, quiet=True)
                print(f"{KaliStyle.SUCCESS} Eliminado {action['dest']}")
        print(f"{KaliStyle.SUCCESS} Cambios revertidos")

    def run(self):
        if not all([self.check_os(), self.check_sudo_privileges(), self.check_required_files(), self.check_graphical_environment()]):
            return False

        os.system('clear')
        self.show_banner()

        if not self.check_gnome_requirements():
            return False

        tasks = [
            (self.install_gnome_extensions, "Instalación de extensiones GNOME"),
            (self.verify_installation, "Verificación de instalación"),
            (self.install_additional_packages, "Instalación de paquetes adicionales"),
            (self.setup_dotfiles, "Configuración de dotfiles"),
            (self.setup_aliases, "Configuración de aliases"),
            (self.install_extract_ports, "Instalación de extractPorts"),
            (self.install_fonts, "Instalación de fuentes"),
            (self.install_sudo_plugin, "Instalación de plugin sudo"),
            (self.install_terminator_config, "Configuración de Terminator"),
            (self.install_kitty_config, "Configuración de Kitty"),
            (self.configure_keyboard_shortcuts, "Configuración de atajos de teclado"),
            (self.setup_wallpaper, "Configuración del fondo de pantalla"),
            (self.setup_browser_wallpaper, "Configuración del fondo de pantalla del navegador"),
            (self.setup_ctf_folders, "Configuración de carpetas para CTF"),
            (self.setup_gdm_wallpaper, "Configuración del fondo de pantalla de GDM")
        ]

        total_tasks = len(tasks)

        try:
            for i, (task, description) in enumerate(tasks, 1):
                print(f"\n{KaliStyle.GREY}{'─' * 40}{KaliStyle.RESET}")
                print(f"{KaliStyle.INFO} ({i}/{total_tasks}) Iniciando {description}...")
                if not task():
                    print(f"{KaliStyle.ERROR} Error en {description}")
                    self.rollback()
                    self.cleanup()
                    return False
                time.sleep(0.5)
            print()

            self.show_final_message()

            if self.needs_gdm_restart:
                print(f"\n{KaliStyle.WARNING} Es necesario reiniciar GDM para aplicar los cambios.")
                user_input = input(f"{KaliStyle.SUDO_COLOR}¿Desea reiniciar GDM ahora? (s/n): {KaliStyle.RESET}").lower()
                if user_input == 's':
                    if not self.run_command(['systemctl', 'restart', 'gdm'], sudo=True, quiet=True):
                        print(f"{KaliStyle.ERROR} No se pudo reiniciar GDM. Por favor, reinicie manualmente con 'sudo systemctl restart gdm'")
                    else:
                        print(f"{KaliStyle.SUCCESS} GDM reiniciado")
                else:
                    print(f"{KaliStyle.WARNING} Por favor, reinicie GDM manualmente con 'sudo systemctl restart gdm'")

            self.cleanup()
            logging.info("Instalación completada exitosamente")
            return True

        except KeyboardInterrupt:
            print(f"\n{KaliStyle.WARNING} Instalación interrumpida")
            self.rollback()
            self.cleanup()
            return False
        except Exception as e:
            print(f"{KaliStyle.ERROR} Error: {str(e)}")
            self.rollback()
            self.cleanup()
            return False

if __name__ == "__main__":
    installer = CombinedInstaller()
    installer.run()
