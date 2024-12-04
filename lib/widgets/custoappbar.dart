import 'package:flutter/material.dart';
import 'package:trabalho/services/authservice.dart';

class AppCustomBar extends StatelessWidget implements PreferredSizeWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('HealthMate'),
      automaticallyImplyLeading: false,
      actions: [
        _auth.currentUser == null
            ? IconButton(
                icon: Icon(Icons.login),
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
              )
            : PopupMenuButton<String>(
                onSelected: (String value) async {
                  if (value == 'logout') {
                    await _auth.signOut(); // Chama o logout
                    Navigator.pushReplacementNamed(context, '/');
                  } else if (value == 'dashboard') {
                    Navigator.pushReplacementNamed(context, '/dashboard');
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'dashboard',
                    child: Text('Dashboard'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                ],
              ),
      ],
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // Tamanho do AppBar
}
