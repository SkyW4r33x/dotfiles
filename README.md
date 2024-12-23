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

![image](https://github.com/user-attachments/assets/be7df8c1-50f2-422b-9be4-650a6afdea80)

## 💻 Nuevo prompt personalizado para Kali Linux

El prompt incluye mejoras visuales y funcionales, diseñadas específicamente para entornos de análisis y desarrollo en **Kali Linux**.

![image](https://github.com/user-attachments/assets/1fa193fc-da59-4ead-b39e-269407c8909c)

### Resultado al ejecutar un comando con error:  
El prompt muestra indicadores visuales claros cuando un comando falla, facilitando la detección de errores.  

**Ejemplo con resultado de error:**

![image](https://github.com/user-attachments/assets/c07d6ee9-9e78-4879-a503-63d67e256aae)

![image](https://github.com/user-attachments/assets/eda2b37a-6a4c-4a65-be5c-b35a2ad68e43)

---
### ✅ Comando `settarget`
Este comando permite establecer información sobre la víctima de un análisis pentesting, mostrando un listado dinámico en el `lsd` personalizado.

```bash
settarget $IP_VICTIMA $NOMBRE_VICTIMA
```

Configuración del objetivo con settarget:

![image](https://github.com/user-attachments/assets/d3b1cbaf-d71b-444a-aefe-d80cce68c772)

Resultado en el listado de directorios personalizado:

![image](https://github.com/user-attachments/assets/078c49eb-d135-4714-9fe0-3ea6ca795a51)

---
## 🛡️ Comandos referenciales para pentesting

El repositorio incluye un conjunto de scripts y comandos optimizados para pentesting, agrupados en funciones específicas:

- **`utilscommon` / `utilscommon1`**: Arsenales de comandos útiles para tareas de pentesting.
- **`treatty`**: Mejora la interacción en TTYs de máquinas objetivo.
- **`vuln`**: Lista y explica vulnerabilidades comunes.

Ejemplo visual del arsenal de comandos del comando **`utilscommon`**:  

![image](https://github.com/user-attachments/assets/620294f2-1ebb-41b3-a3ba-cd02ba5bc9bc)

---

## ⚙️ Herramientas adicionales incluidas

- **`lsd`**: Reemplazo moderno de `ls` con soporte para iconos y colores.
- **`bat`**: Alternativa mejorada al comando `cat`, con resaltado de sintaxis.
- **`terminator`**: Emulador de terminal avanzado para entornos multitarea.

---
