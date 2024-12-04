import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trabalho/models/exercicio.dart';

class ExercicioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para salvar um exercício (inserir ou atualizar)
  Future<void> saveExercicio(Exercicio exercicio) async {
    try {
      await _firestore
          .collection('exercicios')
          .doc(exercicio.exercicioId)
          .set(exercicio.toMap());
    } catch (e) {
      print("Erro ao salvar exercício: $e");
    }
  }

  // Método para buscar todos os exercícios de um usuário
  Future<List<Exercicio>> getExerciciosByUserId(String usuarioId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('exercicios')
          .where('usuarioId', isEqualTo: usuarioId)
          .get();
      return snapshot.docs
          .map((doc) => Exercicio.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Erro ao buscar exercícios: $e");
      return [];
    }
  }

  // Método para excluir um exercício
  Future<void> deleteExercicio(String exercicioId) async {
    try {
      await _firestore.collection('exercicios').doc(exercicioId).delete();
    } catch (e) {
      print("Erro ao excluir exercício: $e");
    }
  }
}
