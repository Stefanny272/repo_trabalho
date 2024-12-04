import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Retorna o usuário atual
  User? get currentUser => _auth.currentUser;

  // Stream para monitorar o estado de autenticação
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Função de cadastro de usuário com email e senha
  Future<UserCredential> signUp(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception(e); // Erro
    }
  }

  // Função de login com email e senha
  Future<UserCredential> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
// Sucesso
    } catch (e) {
      throw Exception(e); // Erro
      // Erro
    }
  }

  // Função de logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Função para alterar a senha do usuário
  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null; // Sucesso
    } catch (e) {
      return e.toString(); // Erro
    }
  }

  // Função para verificar o estado de autenticação
  Future<bool> checkAuthStatus(BuildContext context) async {
    final user = _auth.currentUser;
    if (user == null) {
      return false;
    } else {
      return true;
    }
  }
}
