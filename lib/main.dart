import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:trabalho/screens/DashboardScreen.dart';
import 'package:trabalho/screens/ExercicioListScreen.dart';
import 'package:trabalho/screens/RefeicaoListScreen.dart';
import 'package:trabalho/screens/RegistrationScreen.dart';
import 'package:trabalho/firebase_options.dart';
import 'package:trabalho/screens/SonoListScreen.dart';
import 'package:trabalho/widgets/authwrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    runApp(HealthMateApp());
  } catch (e) {
    print('Error inicializando Firebase: $e');
  }
}

class HealthMateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealthMate',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthWrapper(page: () => DashboardScreen()),
        '/signup': (context) => RegistrationScreen(),
        '/dashboard': (context) => AuthWrapper(page: () => DashboardScreen()),
        '/sonos': (context) => AuthWrapper(page: () => SonoListScreen()),
        '/refeicoes': (context) =>
            AuthWrapper(page: () => RefeicaoListScreen()),
        '/exercicios': (context) =>
            AuthWrapper(page: () => ExercicioListScreen()),
      },
    );
  }
}
