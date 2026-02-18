import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_blocker_provider.dart';
import 'app_provider.dart';
import 'monk_mode_provider.dart';

/// Estado del temporizador de Monk Mode.
class MonkModeTimerState {
  /// Tiempo restante en segundos. 0 si no está activo.
  final int remainingSeconds;

  const MonkModeTimerState({required this.remainingSeconds});

  /// Formatea el tiempo en mm:ss.
  String get formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Indica si el temporizador está activo (tiempo > 0).
  bool get isActive => remainingSeconds > 0;
}

/// Duración del temporizador en segundos (25 minutos).
const int _monkModeDurationSeconds = 25 * 60; // 1500 segundos

/// StateNotifier que gestiona el temporizador de Monk Mode.
///
/// Escucha cambios en [monkModeProvider] y:
/// - Inicia el temporizador cuando Monk Mode se activa.
/// - Actualiza cada segundo.
/// - Desactiva Monk Mode automáticamente al llegar a 0.
class MonkModeTimerNotifier extends StateNotifier<MonkModeTimerState> {
  final Ref _ref;
  Timer? _timer;

  MonkModeTimerNotifier(this._ref) : super(const MonkModeTimerState(remainingSeconds: 0)) {
    // Escuchar cambios en monkModeProvider y reaccionar.
    _ref.listen<bool>(monkModeProvider, (previous, next) {
      if (next && !previous) {
        // Monk Mode se acaba de activar: iniciar temporizador y bloqueo de apps.
        _startTimer();
        _activateAppBlocker();
      } else if (!next && previous) {
        // Monk Mode se desactivó manualmente: detener temporizador y bloqueo.
        _stopTimer();
        _deactivateAppBlocker();
      }
    });
  }

  /// Inicia el temporizador con la duración completa.
  void _startTimer() {
    _stopTimer(); // Asegurar que no hay otro timer corriendo.
    state = MonkModeTimerState(remainingSeconds: _monkModeDurationSeconds);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds <= 1) {
        // Llegó a 0: desactivar Monk Mode, detener temporizador y bloqueo de apps.
        _ref.read(monkModeProvider.notifier).state = false;
        _stopTimer();
        // El listen en el constructor detectará el cambio y llamará a _deactivateAppBlocker()
        // pero lo llamamos explícitamente aquí para asegurar que se ejecute inmediatamente.
        _deactivateAppBlocker();
      } else {
        // Decrementar un segundo.
        state = MonkModeTimerState(remainingSeconds: state.remainingSeconds - 1);
      }
    });
  }

  /// Detiene el temporizador y resetea el estado.
  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    state = const MonkModeTimerState(remainingSeconds: 0);
  }

  /// Activa el bloqueo de apps cuando Monk Mode se activa.
  ///
  /// Obtiene las 3 primeras apps de la lista y las configura como permitidas.
  /// Todas las demás apps quedarán bloqueadas.
  Future<void> _activateAppBlocker() async {
    try {
      final appsAsync = _ref.read(appsProvider);
      final apps = await appsAsync.future;

      // Obtener las 3 primeras apps (las que se muestran en Monk Mode).
      final allowedApps = apps.take(3).map((app) => app.id).toList();

      final blockerService = _ref.read(appBlockerServiceProvider);
      await blockerService.setAllowedApps(allowedApps);
      await blockerService.startMonitoring();
    } catch (e) {
      // En caso de error, solo loguear. No bloquear la activación de Monk Mode.
      // TODO: manejar errores apropiadamente cuando haya implementación real.
    }
  }

  /// Desactiva el bloqueo de apps cuando Monk Mode se desactiva.
  Future<void> _deactivateAppBlocker() async {
    try {
      final blockerService = _ref.read(appBlockerServiceProvider);
      await blockerService.stopMonitoring();
    } catch (e) {
      // En caso de error, solo loguear.
      // TODO: manejar errores apropiadamente cuando haya implementación real.
    }
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}

/// Provider del temporizador de Monk Mode.
final monkModeTimerProvider =
    StateNotifierProvider<MonkModeTimerNotifier, MonkModeTimerState>((ref) {
  return MonkModeTimerNotifier(ref);
});
