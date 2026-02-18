import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_provider.dart';
import '../providers/clock_provider.dart';
import '../../domain/entities/app_entity.dart';

/// Pantalla principal del launcher: fondo negro, texto blanco,
/// hora grande, fecha y lista de apps solo texto. Sin iconos.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clockAsync = ref.watch(clockProvider);
    final appsAsync = ref.watch(appsProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hora actual grande (actualización cada minuto)
              clockAsync.when(
                data: (state) => _ClockSection(time: state.time, date: state.date),
                loading: () => const _ClockSection(time: '--:--', date: '...'),
                error: (_, __) => const _ClockSection(time: '--:--', date: 'Error'),
              ),
              const SizedBox(height: 48),
              // Lista vertical de apps (solo texto)
              Expanded(
                child: appsAsync.when(
                  data: (apps) => _AppList(apps: apps),
                  loading: () => const Center(
                    child: Text(
                      'Cargando...',
                      style: TextStyle(color: Colors.white54, fontSize: 16),
                    ),
                  ),
                  error: (e, _) => Center(
                    child: Text(
                      'Error: $e',
                      style: const TextStyle(color: Colors.white54, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bloque de hora y fecha. Diseño minimalista.
class _ClockSection extends StatelessWidget {
  final String time;
  final String date;

  const _ClockSection({required this.time, required this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 72,
            fontWeight: FontWeight.w200,
            letterSpacing: -2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          date,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 18,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}

/// Lista vertical de apps: solo texto, sin iconos.
class _AppList extends StatelessWidget {
  final List<AppEntity> apps;

  const _AppList({required this.apps});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: apps.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final app = apps[index];
        return _AppTile(displayName: app.displayName);
      },
    );
  }
}

/// Una fila de app: texto blanco, sin icono. Tappable para futuro launch.
class _AppTile extends StatelessWidget {
  final String displayName;

  const _AppTile({required this.displayName});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: integrar lanzamiento de app cuando exista detección real
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          displayName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
