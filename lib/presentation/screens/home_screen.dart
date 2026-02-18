import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_provider.dart';
import '../providers/clock_provider.dart';
import '../providers/monk_mode_provider.dart';
import '../providers/monk_mode_timer_provider.dart';
import '../providers/streak_provider.dart';
import '../../domain/entities/app_entity.dart';

/// Pantalla principal del launcher: fondo negro, texto blanco,
/// hora, fecha, desbloqueos, botón Monk Mode y lista de apps. Sin iconos.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clockAsync = ref.watch(clockProvider);
    final appsAsync = ref.watch(appsProvider);
    final isMonkModeActive = ref.watch(monkModeProvider);
    // Observar el temporizador para que el StateNotifier se inicialice y escuche cambios.
    final timerState = ref.watch(monkModeTimerProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hora y fecha
              clockAsync.when(
                data: (state) => _ClockSection(time: state.time, date: state.date),
                loading: () => const _ClockSection(time: '--:--', date: '...'),
                error: (_, __) => const _ClockSection(time: '--:--', date: 'Error'),
              ),
              const SizedBox(height: 24),
              // Desbloqueos hoy (mockeado)
              const _UnlocksSection(unlocksToday: 12),
              const SizedBox(height: 8),
              // Racha actual (mockeado)
              Consumer(
                builder: (context, ref, _) {
                  final streak = ref.watch(streakProvider);
                  return _StreakSection(streakDays: streak);
                },
              ),
              const SizedBox(height: 40),
              // Botón Activate Monk Mode / Monk Mode Active
              const _MonkModeButton(),
              // Tiempo restante del temporizador (solo si está activo)
              if (timerState.isActive)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    'Tiempo restante: ${timerState.formattedTime}',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              const SizedBox(height: 48),
              // Lista de apps (3 si Monk Mode activo, 6 si no)
              Expanded(
                child: appsAsync.when(
                  data: (apps) {
                    final visibleApps = isMonkModeActive
                        ? apps.take(3).toList()
                        : apps;
                    return _AppList(apps: visibleApps);
                  },
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

/// Sección "Desbloqueos hoy". Valor mockeado por ahora.
class _UnlocksSection extends StatelessWidget {
  final int unlocksToday;

  const _UnlocksSection({required this.unlocksToday});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Desbloqueos hoy: $unlocksToday',
      style: const TextStyle(
        color: Colors.white54,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

/// Sección "Racha actual". Valor mockeado por ahora.
class _StreakSection extends StatelessWidget {
  final int streakDays;

  const _StreakSection({required this.streakDays});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Racha actual: $streakDays ${streakDays == 1 ? 'día' : 'días'}',
      style: const TextStyle(
        color: Colors.white54,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

/// Botón de activar/desactivar Monk Mode. Borde blanco fino, mayúsculas, sin sombras.
/// Muestra diálogo de confirmación cuando Monk Mode está activo.
class _MonkModeButton extends ConsumerWidget {
  const _MonkModeButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = ref.watch(monkModeProvider);
    final label = isActive ? 'MONK MODE ACTIVE' : 'ACTIVATE MONK MODE';

    return GestureDetector(
      onTap: () {
        if (isActive) {
          // Mostrar diálogo de confirmación antes de desactivar.
          _showBreakBlockDialog(context, ref);
        } else {
          // Activar Monk Mode directamente.
          ref.read(monkModeProvider.notifier).state = true;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.zero,
        ),
        child: Text(
          '[ $label ]',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  /// Muestra el diálogo de confirmación para romper el bloque.
  void _showBreakBlockDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (dialogContext) => const _BreakBlockDialog(),
    );
  }
}

/// Diálogo modal minimalista para confirmar romper el bloque de enfoque.
class _BreakBlockDialog extends ConsumerWidget {
  const _BreakBlockDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.white, width: 1),
        borderRadius: BorderRadius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Seguro que quieres romper tu bloque de enfoque?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _DialogButton(
                  label: 'CONTINUAR ENFOQUE',
                  onTap: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 16),
                _DialogButton(
                  label: 'ROMPER BLOQUE',
                  onTap: () {
                    // Resetear racha a 0.
                    ref.read(streakProvider.notifier).state = 0;
                    // Desactivar Monk Mode.
                    ref.read(monkModeProvider.notifier).state = false;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Botón del diálogo: borde blanco fino, texto mayúsculas, sin sombras.
class _DialogButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DialogButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.zero,
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
        ),
      ),
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
