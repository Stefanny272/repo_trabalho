class Sono {
  String? sonoId;
  String? usuarioId;
  double? horasSono;
  int? qualidadeSono;

  // Constructor
  Sono({
    this.sonoId,
    this.usuarioId,
    this.horasSono,
    this.qualidadeSono,
  });

  // Método para convertir la clase a un mapa (útil para bases de datos o APIs)
  Map<String, dynamic> toMap() {
    return {
      'sonoId': sonoId,
      'usuarioId': usuarioId,
      'horasSono': horasSono,
      'qualidadeSono': qualidadeSono,
    };
  }

  // Método para crear una instancia de Sono a partir de un mapa (útil para leer de bases de datos o APIs)
  factory Sono.fromMap(Map<String, dynamic> map) {
    return Sono(
      sonoId: map['sonoId'],
      usuarioId: map['usuarioId'],
      horasSono: map['horasSono']?.toDouble(),
      qualidadeSono: map['qualidadeSono'],
    );
  }

  @override
  String toString() {
    return 'Sono{id: $sonoId, usuarioId: $usuarioId, horasSono: $horasSono, qualidadeSono: $qualidadeSono}';
  }
}
