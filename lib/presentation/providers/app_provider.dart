import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/app_entity.dart';
import '../../domain/repositories/app_repository.dart';
import '../../data/repositories/mock_app_repository.dart';

/// Provee la implementación concreta del [AppRepository].
/// Cambiar a un [RealAppRepository] cuando se integre detección de apps.
final appRepositoryProvider = Provider<AppRepository>((ref) {
  return MockAppRepository();
});

/// Provee la lista de apps para el launcher.
/// Escucha el repositorio inyectado y expone el estado a la UI.
final appsProvider = FutureProvider<List<AppEntity>>((ref) async {
  final repository = ref.watch(appRepositoryProvider);
  return repository.getApps();
});
