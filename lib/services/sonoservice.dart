import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trabalho/models/sono.dart'; // Importe a classe Sono aqui.

class SonoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para criar ou atualizar um sono no Firestore
  Future<void> saveSono(Sono sono) async {
    try {
      await _firestore.collection('sonos').doc(sono.sonoId).set(sono.toMap());
      debugPrint("Sono salvo com sucesso!");
    } catch (e) {
      debugPrint("Erro ao salvar sono: $e");
      rethrow; // Lançar o erro para que seja tratado na camada superior
    }
  }

  // Método para obter todos os registros de Sono
  Future<List<Sono>> getSonos() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('sonos').get();
      return snapshot.docs.map((doc) {
        var mapData = doc.data() as Map<String, dynamic>;
        mapData['id'] = doc.id;
        return Sono.fromMap(mapData);
      }).toList();
    } catch (e) {
      debugPrint("Erro ao obter sonos: $e");
      return [];
    }
  }

  Future<List<Sono>> getSonosByUserId(String userId) async {
    try {
      // Consulta para obter os sonos filtrados pelo userId
      QuerySnapshot snapshot = await _firestore
          .collection('sonos')
          .where('usuarioId',
              isEqualTo: userId) // Filtrando pelos registros do usuário
          .get();

      return snapshot.docs.map((doc) {
        // Transformando os dados em um objeto Sono
        var mapData = doc.data() as Map<String, dynamic>;
        mapData['id'] = doc.id; // Adicionando o id do documento
        return Sono.fromMap(mapData);
      }).toList();
    } catch (e) {
      debugPrint("Erro ao obter sonos: $e");
      return [];
    }
  }

  // Método para obter um sono específico pelo ID
  Future<Sono?> getSonoById(String sonoId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('sonos').doc(sonoId).get();
      if (doc.exists) {
        return Sono.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      debugPrint("Erro ao obter sono por ID: $e");
      return null;
    }
  }

  // Método para excluir um sono pelo ID
  Future<void> deleteSono(String sonoId) async {
    try {
      await _firestore.collection('sonos').doc(sonoId).delete();
      debugPrint("Sono deletado com sucesso!");
    } catch (e) {
      debugPrint("Erro ao deletar sono: $e");
      rethrow;
    }
  }
}
