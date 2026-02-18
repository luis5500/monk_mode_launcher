import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Estado local de Monk Mode: activado o no.
///
/// Solo estado en memoria; sin persistencia ni lógica Android por ahora.
/// Cuando está activo, la UI muestra menos apps y el botón cambia de texto.
final monkModeProvider = StateProvider<bool>((ref) => false);
