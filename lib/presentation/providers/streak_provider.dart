import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Estado de la racha de días consecutivos de Monk Mode.
///
/// Solo estado en memoria; sin persistencia por ahora.
/// Se resetea a 0 cuando el usuario rompe un bloque manualmente.
final streakProvider = StateProvider<int>((ref) => 3); // Mock inicial: 3 días
