/// Entidad de dominio que representa una aplicación en el launcher.
///
/// Contiene solo los datos necesarios para la capa de presentación.
/// Sin iconos ni lógica de plataforma; diseño minimalista.
class AppEntity {
  /// Identificador único (p. ej. package name en Android).
  final String id;

  /// Nombre mostrado en la lista (sin icono).
  final String displayName;

  const AppEntity({
    required this.id,
    required this.displayName,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          displayName == other.displayName;

  @override
  int get hashCode => Object.hash(id, displayName);
}
