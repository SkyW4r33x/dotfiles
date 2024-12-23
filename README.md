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

![image](https://github.com/user-attachments/assets/62ecfcfc-c781-4084-8da0-95e1da908792)

## 💻 Nuevo prompt personalizado para Kali Linux

El prompt incluye mejoras visuales y funcionales, diseñadas específicamente para entornos de análisis y desarrollo en **Kali Linux**.

![Nuevo prompt personalizado](https://github.com/user-attachments/assets/b240185f-ee43-402a-b000-8e22d8ad9d44)

---
### ✅ Comando `settarget`
Este comando permite establecer información sobre la víctima de un análisis pentesting, mostrando un listado dinámico en el `lsd` personalizado.

```bash
settarget $IP_VICTIMA $NOMBRE_VICTIMA
```

Configuración del objetivo con settarget:

![Uso de `settarget`](https://github.com/user-attachments/assets/b7d66083-e7cd-41bc-bf6c-fb8ab09f5ab6)

Resultado en el listado de directorios personalizado:

![image](https://github.com/user-attachments/assets/b613fb83-0ee4-4226-8617-c0324eae3ea2)

---
## 🛡️ Comandos referenciales para pentesting

El repositorio incluye un conjunto de scripts y comandos optimizados para pentesting, agrupados en funciones específicas:

- **`utilscommon` / `utilscommon1`**: Arsenales de comandos útiles para tareas de pentesting.
- **`treatty`**: Mejora la interacción en TTYs de máquinas objetivo.
- **`vuln`**: Lista y explica vulnerabilidades comunes.

Ejemplo visual del arsenal de comandos del comando **`utilscommon`**:  

![Referencias de pentesting](https://github.com/user-attachments/assets/02dcc37e-dc5e-425e-8de0-9fb1aee2ec45)

---

## ⚙️ Herramientas adicionales incluidas

- **`lsd`**: Reemplazo moderno de `ls` con soporte para iconos y colores.
- **`bat`**: Alternativa mejorada al comando `cat`, con resaltado de sintaxis.
- **`terminator`**: Emulador de terminal avanzado para entornos multitarea.

---
