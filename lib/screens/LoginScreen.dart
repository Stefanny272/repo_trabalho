import 'package:flutter/material.dart';
import 'package:trabalho/services/authservice.dart';
import 'package:trabalho/widgets/custoappbar.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _auth = AuthService();

  // Função para exibir mensagens de erro
  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppCustomBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Bem-vindo ao HealthMate!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // Campo de E-mail
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10),
            // Campo de Senha
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            // Botão de Login
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text.trim();
                final password = passwordController.text.trim();

                // Validação de e-mail
                if (email.isEmpty ||
                    !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
                  _showErrorMessage(
                      context, 'Por favor, insira um e-mail válido.');
                  return;
                }

                // Validação de senha
                if (password.isEmpty) {
                  _showErrorMessage(context, 'Por favor, insira sua senha.');
                  return;
                }

                // Chamada para o serviço de autenticação
                try {
                  final result = await _auth.signIn(email, password);
                  if (result != null) {
                    // Navegar para a tela de dashboard
                    Navigator.pushNamed(context, '/dashboard');
                  } else {
                    _showErrorMessage(context, 'E-mail ou senha inválidos.');
                  }
                } catch (e) {
                  _showErrorMessage(
                      context, 'Erro ao tentar fazer login. Tente novamente.');
                }
              },
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            // Link para tela de cadastro
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Text('Não tem conta? Cadastre-se'),
            ),
          ],
        ),
      ),
    );
  }
}
