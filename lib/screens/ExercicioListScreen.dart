import 'package:flutter/material.dart';
import 'package:trabalho/services/exercicioservice.dart';
import 'package:trabalho/models/exercicio.dart';
import 'package:trabalho/services/authservice.dart';
import 'package:trabalho/widgets/custoappbar.dart';

class ExercicioListScreen extends StatefulWidget {
  @override
  _ExercicioListScreenState createState() => _ExercicioListScreenState();
}

class _ExercicioListScreenState extends State<ExercicioListScreen> {
  final ExercicioService _exercicioService = ExercicioService();
  final _auth = AuthService();
  List<Exercicio> _exercicios = [];

  @override
  void initState() {
    super.initState();
    _loadExercicios();
  }

  // Carregar os exercícios do Firebase
  void _loadExercicios() async {
    List<Exercicio> exercicios =
        await _exercicioService.getExerciciosByUserId(_auth.currentUser!.uid);
    setState(() {
      _exercicios = exercicios;
    });
  }

  // Excluir um exercício
  void _deleteExercicio(String exercicioId) async {
    await _exercicioService.deleteExercicio(exercicioId);
    _loadExercicios(); // Recarregar a lista após exclusão
  }

  // Mostrar o modal para editar ou adicionar um exercício
  void _showEditModal({Exercicio? exercicio}) {
    final TextEditingController tipoDeExercicioController =
        TextEditingController(text: exercicio?.tipoDeExercicio);
    final TextEditingController duracaoController =
        TextEditingController(text: exercicio?.duracao?.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(exercicio == null
              ? 'Adicionar Novo Exercício'
              : 'Editar Exercício'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tipoDeExercicioController,
                decoration: InputDecoration(labelText: 'Tipo de Exercício'),
              ),
              TextField(
                controller: duracaoController,
                decoration: InputDecoration(labelText: 'Duração (minutos)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final String tipoDeExercicio = tipoDeExercicioController.text;
                final int? duracao = int.tryParse(duracaoController.text);

                if (tipoDeExercicio.isEmpty ||
                    duracao == null ||
                    duracao <= 0) {
                  return; // Você pode adicionar uma validação aqui
                }

                if (exercicio == null) {
                  // Adicionar novo exercício
                  Exercicio novoExercicio = Exercicio(
                    exercicioId: DateTime.now().toString(), // Gerar um ID único
                    usuarioId: _auth.currentUser!.uid,
                    tipoDeExercicio: tipoDeExercicio,
                    duracao: duracao,
                  );
                  _exercicioService.saveExercicio(novoExercicio);
                } else {
                  // Editar exercício existente
                  Exercicio exercicioEditado = Exercicio(
                    exercicioId: exercicio.exercicioId,
                    usuarioId: exercicio.usuarioId,
                    tipoDeExercicio: tipoDeExercicio,
                    duracao: duracao,
                  );
                  _exercicioService.saveExercicio(exercicioEditado);
                }

                _loadExercicios();
                Navigator.of(context).pop();
              },
              child: Text(exercicio == null ? 'Adicionar' : 'Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppCustomBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Registro de Exercícios',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _exercicios.length,
                itemBuilder: (context, index) {
                  final exercicio = _exercicios[index];
                  return ListTile(
                    title: Text(exercicio.tipoDeExercicio!),
                    subtitle: Text('Duração: ${exercicio.duracao} minutos'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showEditModal(exercicio: exercicio);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () =>
                              _deleteExercicio(exercicio.exercicioId!),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditModal(),
        child: Icon(Icons.add),
      ),
    );
  }
}
