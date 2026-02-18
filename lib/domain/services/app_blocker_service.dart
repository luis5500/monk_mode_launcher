/// Servicio abstracto para bloquear aplicaciones durante Monk Mode.
///
/// Define el contrato que debe implementar cualquier servicio de bloqueo.
/// La implementación real usará platform channels para comunicarse con Android.
abstract class AppBlockerService {
  /// Inicia el monitoreo de aplicaciones.
  ///
  /// Debe configurar listeners o servicios nativos para detectar
  /// cuando el usuario intenta abrir apps bloqueadas.
  Future<void> startMonitoring();

  /// Detiene el monitoreo de aplicaciones.
  ///
  /// Libera recursos y desactiva cualquier listener o servicio nativo.
  Future<void> stopMonitoring();

  /// Establece la lista de aplicaciones permitidas.
  ///
  /// [packageNames] Lista de package names (IDs) de apps que pueden ejecutarse.
  /// Todas las demás apps quedarán bloqueadas mientras el monitoreo esté activo.
  Future<void> setAllowedApps(List<String> packageNames);
}
