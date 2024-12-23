# dotfiles
Un repositorio con mis configuraciones personalizadas para **ZSH**, **Neovim con NvChad**, y comandos referenciales útiles para **pentesting**. Incluye scripts, herramientas y personalizaciones para optimizar tu flujo de trabajo.
---
## 🚀 Características principales
- Configuración avanzada para **ZSH** con un prompt personalizado.
- Instalación y configuración de **Neovim 0.10** utilizando **NvChad**.
- Referencias y arsenales de comandos específicos para **pentesting**.
- Personalización de herramientas: `lsd`, `bat`, `terminator`, entre otras.
- Integración de comandos útiles para gestionar objetivos y tareas.
---
## 🛠️ Proceso de instalación
1. Clona este repositorio:
   ```bash
   git clone https://github.com/SkyW4r33x/dotfiles.git
   ```
2. Asigna permisos de ejecución al script:
   ```bash
   chmod +x install.sh
   ```
3. Ejecuta el script de instalación:
   ```bash
   ./install.sh
   ```
4. Sigue las instrucciones en pantalla para personalizar las configuraciones.
---
## 🎨 Personalizaciones incluidas
### ✅ Customización del listado de directorios
La configuración del comando `ls` (mediante `lsd`) incluye colores y estilos mejorados para identificar rápidamente archivos y directorios importantes.

![image](https://github.com/user-attachments/assets/c8162ca6-0933-4626-983b-469f15e2f2e2)

## 💻 Nuevo prompt personalizado para Kali Linux
El prompt incluye mejoras visuales y funcionales, diseñadas específicamente para entornos de análisis y desarrollo en **Kali Linux**.

![image](https://github.com/user-attachments/assets/b079dda3-a54a-462f-8354-f8d5604564ad)

### Resultado al ejecutar un comando con error:  
El prompt muestra indicadores visuales claros cuando un comando falla, facilitando la detección de errores.  
**Ejemplo con resultado de error:**

![image](https://github.com/user-attachments/assets/9bbaa387-8a6c-431b-b3a2-b21f639be0e0)

![image](https://github.com/user-attachments/assets/24028713-0b53-43f2-8850-3da1553f09e0)

---
### ✅ Comando `settarget`
Este comando permite establecer información sobre la víctima de un análisis pentesting, mostrando un listado dinámico en el `lsd` personalizado.
```bash
settarget $IP_VICTIMA $NOMBRE_VICTIMA
```
Configuración del objetivo con settarget:

![image](https://github.com/user-attachments/assets/a04d726e-7a71-49ce-9d2d-0b7071eb5c78)

Resultado en el listado de directorios personalizado:

![image](https://github.com/user-attachments/assets/98015439-22e3-4a62-9b08-a190deb17646)

---
## 🛡️ Comandos referenciales para pentesting
El repositorio incluye un conjunto de scripts y comandos optimizados para pentesting, agrupados en funciones específicas:
- **`utilscommon` / `utilscommon1`**: Arsenales de comandos útiles para tareas de pentesting.
- **`treatty`**: Mejora la interacción en TTYs de máquinas objetivo.
- **`vuln`**: Lista y explica vulnerabilidades comunes.
Ejemplo visual del arsenal de comandos del comando **`utilscommon`**:

![image](https://github.com/user-attachments/assets/cf7658b4-f7c2-4a2f-a06f-a56bd3701363)

---
## ⚙️ Herramientas adicionales incluidas
- **`lsd`**: Reemplazo moderno de `ls` con soporte para iconos y colores.
- **`bat`**: Alternativa mejorada al comando `cat`, con resaltado de sintaxis.
- **`terminator`**: Emulador de terminal avanzado para entornos multitarea.
---
