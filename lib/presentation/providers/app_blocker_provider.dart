import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/app_blocker_service.dart';
import '../../data/services/mock_app_blocker_service.dart';

/// Provee la implementación concreta del [AppBlockerService].
///
/// Por ahora inyecta [MockAppBlockerService]. Más adelante se cambiará
/// por una implementación real que use platform channels.
final appBlockerServiceProvider = Provider<AppBlockerService>((ref) {
  return MockAppBlockerService();
});
