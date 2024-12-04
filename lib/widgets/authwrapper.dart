import 'package:flutter/material.dart';
import 'package:trabalho/services/authservice.dart';
import 'package:trabalho/screens/LoginScreen.dart';

class AuthWrapper extends StatelessWidget {
  final AuthService _auth = AuthService();

  // Recebe a página a ser exibida como parâmetro
  final Widget Function() page;

  // Recebe a página no construtor
  AuthWrapper({required this.page});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _auth
          .checkAuthStatus(context), // Verifica se o usuário está autenticado
      builder: (context, snapshot) {
        // Quando o Future estiver sendo carregado, você pode exibir um loader ou algo do tipo.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        // Quando o status de autenticação for verificado, navegue para a tela correta.
        if (snapshot.hasData && snapshot.data == true) {
          // O usuário está autenticado, retorna a página
          return page();
        } else {
          // O usuário não está autenticado, redireciona para a tela de login
          return LoginScreen();
        }
      },
    );
  }
}
