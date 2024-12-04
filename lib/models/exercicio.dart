class Exercicio {
  String? exercicioId;
  String? usuarioId;
  String?
      tipoDeExercicio; // Tipo de exercício (ex: Caminhada, Corrida, Musculação)
  int? duracao; // Duração do exercício em minutos

  Exercicio({
    this.exercicioId,
    this.usuarioId,
    this.tipoDeExercicio,
    this.duracao,
  });

  // Método para converter o modelo para um mapa (útil para Firebase)
  Map<String, dynamic> toMap() {
    return {
      'exercicioId': exercicioId,
      'usuarioId': usuarioId,
      'tipoDeExercicio': tipoDeExercicio,
      'duracao': duracao,
    };
  }

  // Método para criar uma instância do modelo a partir de um mapa
  factory Exercicio.fromMap(Map<String, dynamic> map) {
    return Exercicio(
      exercicioId: map['exercicioId'],
      usuarioId: map['usuarioId'],
      tipoDeExercicio: map['tipoDeExercicio'],
      duracao: map['duracao'],
    );
  }
}
