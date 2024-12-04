import 'package:flutter/material.dart';
import 'package:trabalho/services/authservice.dart';
import 'package:trabalho/services/refeicaoservice.dart';
import 'package:trabalho/models/refeicao.dart';
import 'package:trabalho/widgets/custoappbar.dart';

class RefeicaoListScreen extends StatefulWidget {
  @override
  _RefeicaoListScreenState createState() => _RefeicaoListScreenState();
}

class _RefeicaoListScreenState extends State<RefeicaoListScreen> {
  final RefeicaoService _refeicaoService = RefeicaoService();
  final AuthService _auth = AuthService();
  List<Refeicao> _refeicoes = [];

  // Lista com as opções de refeição
  final List<String> _opcoesRefeicao = [
    "Café da Manhã",
    "Almoço",
    "Jantar",
    "Lanche"
  ];
  String _selectedRefeicao = "Café da Manhã"; // Valor inicial

  @override
  void initState() {
    super.initState();
    _loadRefeicoes();
  }

  // Carregar as refeições do Firestore
  void _loadRefeicoes() async {
    List<Refeicao> refeicoes =
        await _refeicaoService.getRefeicoesByUserId(_auth.currentUser!.uid);
    setState(() {
      _refeicoes = refeicoes;
    });
  }

  // Excluir uma refeição
  void _deleteRefeicao(String refeicaoId) async {
    await _refeicaoService.deleteRefeicao(refeicaoId);
    _loadRefeicoes(); // Recarregar a lista após exclusão
  }

  // Mostrar modal para adicionar ou editar uma refeição
  void _showEditModal({Refeicao? refeicao}) {
    final TextEditingController caloriasController =
        TextEditingController(text: refeicao?.calorias?.toString());

    if (refeicao != null) {
      _selectedRefeicao = refeicao.refeicao ??
          "Café da Manhã"; // Atualizar a refeição se editando
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text(refeicao == null ? 'Adicionar Refeição' : 'Editar Refeição'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dropdown para selecionar o tipo de refeição
              DropdownButton<String>(
                value: _selectedRefeicao,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRefeicao = newValue!;
                  });
                },
                items: _opcoesRefeicao
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              TextField(
                controller: caloriasController,
                decoration: InputDecoration(labelText: 'Calorias'),
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
                final double? calorias =
                    double.tryParse(caloriasController.text);

                if (calorias == null) {
                  return; // Validar se as calorias são válidas
                }

                if (refeicao == null) {
                  // Adicionar novo refeição
                  Refeicao novaRefeicao = Refeicao(
                    refeicaoId: DateTime.now().toString(), // Gerar um ID único
                    usuarioId: _auth
                        .currentUser!.uid, // Pode ser o ID do usuário logado
                    refeicao: _selectedRefeicao,
                    calorias: calorias,
                  );
                  _refeicaoService.saveRefeicao(novaRefeicao);
                } else {
                  // Editar refeição existente
                  Refeicao refeicaoEditada = Refeicao(
                    refeicaoId: refeicao.refeicaoId,
                    usuarioId: refeicao.usuarioId,
                    refeicao: _selectedRefeicao,
                    calorias: calorias,
                  );
                  _refeicaoService.saveRefeicao(refeicaoEditada);
                }

                _loadRefeicoes(); // Recarregar a lista após salvar
                Navigator.of(context).pop();
              },
              child: Text(refeicao == null ? 'Adicionar' : 'Salvar'),
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
              'Registro de Refeições',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _refeicoes.length,
                itemBuilder: (context, index) {
                  final refeicao = _refeicoes[index];
                  return ListTile(
                    title: Text('Refeição: ${refeicao.refeicao}'),
                    subtitle: Text('Calorias: ${refeicao.calorias}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showEditModal(refeicao: refeicao);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () =>
                              _deleteRefeicao(refeicao.refeicaoId!),
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
