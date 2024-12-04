import 'package:flutter/material.dart';
import 'package:trabalho/services/authservice.dart';
import 'package:trabalho/services/sonoservice.dart';
import 'package:trabalho/models/sono.dart';
import 'package:trabalho/widgets/custoappbar.dart';

class SonoListScreen extends StatefulWidget {
  @override
  _SonoListScreenState createState() => _SonoListScreenState();
}

class _SonoListScreenState extends State<SonoListScreen> {
  final SonoService _sonoService = SonoService();
  final _auth = AuthService();
  List<Sono> _sonos = [];

  @override
  void initState() {
    super.initState();
    _loadSonos();
  }

  // Carregar os registros de sono
  void _loadSonos() async {
    List<Sono> sonos =
        await _sonoService.getSonosByUserId(_auth.currentUser!.uid);
    setState(() {
      _sonos = sonos;
    });
  }

  // Excluir um sono
  void _deleteSono(String sonoId) async {
    await _sonoService.deleteSono(sonoId);
    _loadSonos(); // Recarregar a lista após exclusão
  }

  // Mostrar modal para edição ou criação de sono
  void _showEditModal({Sono? sono}) {
    final TextEditingController horasSonoController =
        TextEditingController(text: sono?.horasSono?.toString());
    final TextEditingController qualidadeSonoController =
        TextEditingController(text: sono?.qualidadeSono?.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(sono == null ? 'Adicionar Novo Sono' : 'Editar Sono'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: horasSonoController,
                decoration: InputDecoration(labelText: 'Horas de Sono'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: qualidadeSonoController,
                decoration:
                    InputDecoration(labelText: 'Qualidade do Sono (1-10)'),
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
                final double? horasSono =
                    double.tryParse(horasSonoController.text);
                final int? qualidadeSono =
                    int.tryParse(qualidadeSonoController.text);

                if (horasSono == null || horasSono <= 0) {
                  // Verifica se o valor de horas de sono é válido
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Horas de sono inválidas!')),
                  );
                  return;
                }

                if (qualidadeSono == null ||
                    qualidadeSono < 1 ||
                    qualidadeSono > 10) {
                  // Verifica se o valor de qualidade do sono está entre 1 e 10
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Qualidade do sono deve ser entre 1 e 10!')),
                  );
                  return;
                }

                if (sono == null) {
                  // Adicionar novo sono
                  Sono novoSono = Sono(
                    sonoId: DateTime.now().toString(), // Gerar um ID único
                    usuarioId: _auth.currentUser!.uid,
                    horasSono: horasSono,
                    qualidadeSono: qualidadeSono,
                  );
                  _sonoService.saveSono(novoSono);
                } else {
                  // Editar sono existente
                  Sono sonoEditado = Sono(
                    sonoId: sono.sonoId,
                    usuarioId: sono.usuarioId,
                    horasSono: horasSono,
                    qualidadeSono: qualidadeSono,
                  );
                  _sonoService.saveSono(sonoEditado);
                }

                _loadSonos();
                Navigator.of(context).pop();
              },
              child: Text(sono == null ? 'Adicionar' : 'Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _auth.checkAuthStatus(context);

    return Scaffold(
      appBar: AppCustomBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Registro de Sono',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _sonos.length,
                itemBuilder: (context, index) {
                  final sono = _sonos[index];
                  return ListTile(
                    subtitle: Text(
                        'Horas de Sono: ${sono.horasSono}h\nQualidade: ${sono.qualidadeSono}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showEditModal(sono: sono);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteSono(sono.sonoId!),
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
