import '../entities/app_entity.dart';

/// Contrato del repositorio de aplicaciones.
///
/// La capa de datos implementará este contrato (mock ahora,
/// detección real de apps instaladas más adelante).
abstract class AppRepository {
  /// Obtiene la lista de aplicaciones a mostrar en el launcher.
  Future<List<AppEntity>> getApps();
}
