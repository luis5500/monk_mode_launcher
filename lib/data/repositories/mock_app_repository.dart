import '../../domain/entities/app_entity.dart';
import '../../domain/repositories/app_repository.dart';

/// Implementación mock del [AppRepository].
///
/// Devuelve una lista fija de 6 apps para desarrollo y UI
/// sin depender de la detección real de apps instaladas.
class MockAppRepository implements AppRepository {
  static const List<AppEntity> _mockApps = [
    AppEntity(id: 'chrome', displayName: 'Chrome'),
    AppEntity(id: 'whatsapp', displayName: 'WhatsApp'),
    AppEntity(id: 'gmail', displayName: 'Gmail'),
    AppEntity(id: 'calendar', displayName: 'Calendar'),
    AppEntity(id: 'notion', displayName: 'Notion'),
    AppEntity(id: 'spotify', displayName: 'Spotify'),
  ];

  @override
  Future<List<AppEntity>> getApps() async {
    // Simula un pequeño delay de red/IO.
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return List<AppEntity>.unmodifiable(_mockApps);
  }
}
