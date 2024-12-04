class Refeicao {
  String? refeicaoId;
  String? usuarioId;
  String? refeicao; // Tipo de refeição (Café da Manhã, Almoço, Jantar, Lanche)
  double? calorias;

  // Construtor
  Refeicao({this.refeicaoId, this.usuarioId, this.refeicao, this.calorias});

  // Método para converter o objeto Refeicao para Map, necessário para salvar no Firestore
  Map<String, dynamic> toMap() {
    return {
      'refeicaoId': refeicaoId,
      'usuarioId': usuarioId,
      'refeicao': refeicao,
      'calorias': calorias,
    };
  }

  // Método para criar um objeto Refeicao a partir de um Map, usado ao recuperar dados do Firestore
  factory Refeicao.fromMap(Map<String, dynamic> map) {
    return Refeicao(
      refeicaoId: map['refeicaoId'],
      usuarioId: map['usuarioId'],
      refeicao: map['refeicao'],
      calorias: map['calorias'],
    );
  }
}
