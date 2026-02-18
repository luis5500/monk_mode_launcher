# Publicar en GitHub

El repositorio local ya tiene el commit **v0.1** con mensaje:

```
v0.1: base minimalista del launcher

- Fondo negro, texto blanco, sin iconos
- Hora y fecha en la parte superior (actualización cada minuto)
- Lista de 6 apps mockeadas (Chrome, WhatsApp, Gmail, Calendar, Notion, Spotify)
- Arquitectura domain/data/presentation con Riverpod
- AppEntity, AppRepository y MockAppRepository listos para integrar detección real
```

## Pasos

1. **Crear el repositorio en GitHub**
   - Entra en https://github.com/new
   - Nombre: `monk_mode_launcher`
   - Descripción (opcional): *Launcher minimalista Flutter. Fondo negro, texto blanco, hora y lista de apps (v0.1).*
   - Elige **Public**.
   - **No** marques "Add a README" ni .gitignore (ya los tienes en local).
   - Pulsa **Create repository**.

2. **Conectar y subir** (en la carpeta del proyecto):
   ```bash
   cd monk_mode_launcher
   git remote add origin https://github.com/TU_USUARIO/monk_mode_launcher.git
   git branch -M main
   git push -u origin main
   ```
   Sustituye `TU_USUARIO` por tu usuario de GitHub.

Si usas SSH:
   ```bash
   git remote add origin git@github.com:TU_USUARIO/monk_mode_launcher.git
   git branch -M main
   git push -u origin main
   ```

(Opcional) Crear etiqueta v0.1:
   ```bash
   git tag v0.1.0
   git push origin v0.1.0
   ```
