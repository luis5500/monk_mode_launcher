import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Estado actual de reloj: hora y fecha formateadas.
class ClockState {
  final String time;
  final String date;

  const ClockState({required this.time, required this.date});
}

/// Provee la hora actual y la fecha, actualizándose cada minuto.
///
/// Emite el valor inicial de inmediato y luego cada minuto.
final clockProvider = StreamProvider<ClockState>((ref) async* {
  yield _now();
  yield* Stream.periodic(const Duration(minutes: 1), (_) => _now());
});

ClockState _now() {
  final now = DateTime.now();
  final time = _formatTime(now);
  final date = _formatDate(now);
  return ClockState(time: time, date: date);
}

String _formatTime(DateTime d) {
  final h = d.hour.toString().padLeft(2, '0');
  final m = d.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

String _formatDate(DateTime d) {
  const weekdays = [
    'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'
  ];
  const months = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ];
  // DateTime.weekday: 1 = Monday, 7 = Sunday
  final weekday = weekdays[d.weekday - 1];
  final month = months[d.month - 1];
  return '$weekday, ${d.day} de $month';
}
