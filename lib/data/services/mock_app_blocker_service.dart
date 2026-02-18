import 'dart:developer' as developer;

import '../../domain/services/app_blocker_service.dart';

/// Implementación mock del [AppBlockerService].
///
/// Solo imprime logs para desarrollo. No bloquea apps reales.
/// Más adelante se reemplazará por una implementación real que use
/// platform channels para comunicarse con código nativo Android.
class MockAppBlockerService implements AppBlockerService {
  bool _isMonitoring = false;
  List<String> _allowedApps = [];

  @override
  Future<void> startMonitoring() async {
    if (_isMonitoring) {
      developer.log('AppBlocker: Ya está monitoreando');
      return;
    }

    _isMonitoring = true;
    developer.log(
      'AppBlocker: Iniciando monitoreo. Apps permitidas: ${_allowedApps.length}',
    );
    developer.log('AppBlocker: Apps permitidas: $_allowedApps');
  }

  @override
  Future<void> stopMonitoring() async {
    if (!_isMonitoring) {
      developer.log('AppBlocker: No está monitoreando');
      return;
    }

    _isMonitoring = false;
    developer.log('AppBlocker: Deteniendo monitoreo');
    _allowedApps = [];
  }

  @override
  Future<void> setAllowedApps(List<String> packageNames) async {
    _allowedApps = List<String>.unmodifiable(packageNames);
    developer.log(
      'AppBlocker: Configurando ${packageNames.length} apps permitidas',
    );
    developer.log('AppBlocker: Package names: $packageNames');

    if (_isMonitoring) {
      developer.log('AppBlocker: Monitoreo activo, aplicando nueva configuración');
    }
  }

  /// Indica si el servicio está monitoreando actualmente.
  bool get isMonitoring => _isMonitoring;

  /// Obtiene la lista actual de apps permitidas.
  List<String> get allowedApps => List.unmodifiable(_allowedApps);
}
