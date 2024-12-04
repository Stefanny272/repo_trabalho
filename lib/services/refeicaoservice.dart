import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trabalho/models/refeicao.dart'; // Importe o modelo Refeicao aqui

class RefeicaoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para adicionar ou atualizar uma refeição no Firestore
  Future<void> saveRefeicao(Refeicao refeicao) async {
    try {
      await _firestore
          .collection('refeicoes')
          .doc(refeicao.refeicaoId)
          .set(refeicao.toMap());
      print("Refeição salva com sucesso!");
    } catch (e) {
      print("Erro ao salvar refeição: $e");
      rethrow;
    }
  }

  // Método para obter todas as refeições do Firestore
  Future<List<Refeicao>> getRefeicoesByUserId(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('refeicoes')
          .where('usuarioId',
              isEqualTo: userId) // Filtra as refeições pelo ID do usuário
          .get();

      return snapshot.docs.map((doc) {
        return Refeicao.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print("Erro ao obter refeições: $e");
      return [];
    }
  }

  // Método para excluir uma refeição pelo ID
  Future<void> deleteRefeicao(String refeicaoId) async {
    try {
      await _firestore.collection('refeicoes').doc(refeicaoId).delete();
      print("Refeição deletada com sucesso!");
    } catch (e) {
      print("Erro ao deletar refeição: $e");
      rethrow;
    }
  }
}
