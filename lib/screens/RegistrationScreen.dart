import 'package:flutter/material.dart';
import 'package:trabalho/services/authservice.dart';

class RegistrationScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
      appBar: AppBar(
        title: const Text('Cadastro'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Criar Conta',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
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
            const SizedBox(height: 10),
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
            const SizedBox(height: 20),
            // Botão de Cadastro
            ElevatedButton(
              onPressed: () async {
                String email = emailController.text.trim();
                String password = passwordController.text.trim();

                // Validação de e-mail
                if (email.isEmpty ||
                    !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
                  _showErrorMessage(
                      context, 'Por favor, insira um e-mail válido.');
                  return;
                }

                // Validação de senha
                if (password.isEmpty || password.length < 6) {
                  _showErrorMessage(
                      context, 'A senha deve ter pelo menos 6 caracteres.');
                  return;
                }

                // Chamada para o serviço de autenticação
                try {
                  final result = await AuthService().signUp(email, password);
                  if (result != null) {
                    // Navegar para a tela inicial ou outra tela
                    Navigator.pushNamed(context, '/');
                  } else {
                    _showErrorMessage(
                        context, 'Erro ao tentar cadastrar. Tente novamente.');
                  }
                } catch (e) {
                  _showErrorMessage(
                      context, 'Erro ao tentar cadastrar. Tente novamente.');
                }
              },
              child: const Text('Cadastrar'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
