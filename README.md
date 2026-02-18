# Monk Mode Launcher

Launcher minimalista enfocado en alto rendimiento. Fondo negro, texto blanco, sin iconos.

## Estructura del proyecto

```
lib/
├── main.dart
├── data/
│   └── repositories/
│       └── mock_app_repository.dart   # Implementación mock del repositorio
├── domain/
│   ├── entities/
│   │   └── app_entity.dart            # Modelo de app
│   └── repositories/
│       └── app_repository.dart        # Contrato del repositorio
└── presentation/
    ├── providers/
    │   ├── app_provider.dart          # Riverpod: apps y repositorio
    │   └── clock_provider.dart        # Riverpod: hora/fecha (cada minuto)
    └── screens/
        └── home_screen.dart           # Pantalla principal
```

## Cómo ejecutar

1. Si aún no tienes las carpetas de plataforma (android, ios, web), genera el proyecto dentro de esta carpeta:
   ```bash
   cd monk_mode_launcher
   flutter create .
   ```
2. Instala dependencias y ejecuta:
   ```bash
   flutter pub get
   flutter run
   ```

## Arquitectura

- **Domain**: entidades y contratos (repositorios). Sin dependencias de Flutter.
- **Data**: implementaciones concretas (por ahora solo mock de apps).
- **Presentation**: pantallas y providers (Riverpod). Cuando se integre la detección real de apps, se sustituye `MockAppRepository` por la implementación real y se inyecta vía `appRepositoryProvider`.

## Próximos pasos

- Integrar detección real de apps instaladas (platform channel o plugin).
- Añadir lanzamiento de app al pulsar cada ítem.
