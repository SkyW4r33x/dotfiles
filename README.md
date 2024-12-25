# dotfiles

Un repositorio que reúne mis configuraciones personalizadas para entornos de desarrollo y análisis.  

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
---
## 🎨 Personalizaciones incluidas
### ✅ Customización del listado de directorios
La configuración del comando `ls` (mediante `lsd`) incluye colores y estilos mejorados para identificar rápidamente archivos y directorios importantes.

![image](https://github.com/user-attachments/assets/acf493a6-47cb-4f7d-a31d-71edef54d7be)

## 💻 Nuevo prompt personalizado para Kali Linux
El prompt incluye mejoras visuales y funcionales, diseñadas específicamente para entornos de análisis y desarrollo en **Kali Linux**.

![image](https://github.com/user-attachments/assets/2c383319-a4f9-4492-bebc-8d463ca5df8e)

### Resultado al ejecutar un comando con error:  
El prompt muestra indicadores visuales claros cuando un comando falla, facilitando la detección de errores.  
**Ejemplo con resultado de error:**

![image](https://github.com/user-attachments/assets/a38e5fbd-4271-45db-949f-60037cbb6a9a)

![image](https://github.com/user-attachments/assets/aa41265f-05ca-41c3-b990-6577e78d5a93)

---
### ✅ Comando `settarget`
Este comando permite establecer información sobre la víctima de un análisis pentesting, mostrando un listado dinámico en el `lsd` personalizado.
```bash
settarget $IP_VICTIMA $NOMBRE_VICTIMA
```
Configuración del objetivo con settarget:

![image](https://github.com/user-attachments/assets/4a1aa754-7d59-42f8-8f78-a74226bd8f2e)

Resultado en el listado de directorios personalizado:

![image](https://github.com/user-attachments/assets/a5ed34d3-00ae-460c-867f-2736af8d117d)

---
## 🛡️ Comandos referenciales para pentesting
El repositorio incluye un conjunto de scripts y comandos optimizados para pentesting, agrupados en funciones específicas:
- **`utilscommon` / `utilscommon1`**: Arsenales de comandos útiles para tareas de pentesting.
- **`treatty`**: Mejora la interacción en TTYs de máquinas objetivo.
- **`vuln`**: Lista y explica vulnerabilidades comunes.
Ejemplo visual del arsenal de comandos del comando **`utilscommon`**:

![image](https://github.com/user-attachments/assets/d7e10174-494a-4cd6-aac2-6b85aa3acff9)

---
## ⚙️ Herramientas adicionales incluidas
- **`lsd`**: Reemplazo moderno de `ls` con soporte para iconos y colores.
- **`bat`**: Alternativa mejorada al comando `cat`, con resaltado de sintaxis.
- **`terminator`**: Emulador de terminal avanzado para entornos multitarea.
  
---
## 🚀 ¡Nueva Actualización Emocionante!
**`extracPorts`**, inspirado en S4vitar y desarrollado en Python, ahora te permite:  
- Extraer **puertos abiertos** automáticamente desde la salida de Nmap.  
- Generar el comando para escanear **versiones y servicios**.  
- Copiarlo directo a la clipboard para mayor rapidez.
## 📦 Cómo Usarlo:
```bash
   extracPorts.py resultados_nmap
```
## 🖼️ Vista Previa:
![image](https://github.com/user-attachments/assets/8a5cabd3-9c77-4610-adad-5f251c4f2e0f)


