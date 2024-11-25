// lib/models/tarefa_model.dart
class Tarefa {
  final String nome;
  final String descricao;
  final String tipo;
  final String frequencia;
  final List<bool> diasSelecionados;
  final TimeOfDay horario;

  Tarefa({
    required this.nome,
    required this.descricao,
    required this.tipo,
    required this.frequencia,
    required this.diasSelecionados,
    required this.horario,
  });
}

// lib/utils/constants.dart
class TarefaConstants {
  static const List<String> tiposTarefa = [
    'Verificar pressão',
    'Medicação',
    'Exercício',
    'Consulta'
  ];

  static const List<String> frequencias = [
    '1 vez ao dia', 
    '2 vezes ao dia', 
    '3 vezes ao dia'
  ];

  static const List<String> diasSemana = [
    'Segunda', 'Terça', 'Quarta', 
    'Quinta', 'Sexta', 'Sábado', 'Domingo'
  ];
}

// lib/screens/adicionar_tarefa_screen.dart
import 'package:flutter/material.dart';
import '../models/tarefa_model.dart';
import '../utils/constants.dart';

class AdicionarTarefaScreen extends StatefulWidget {
  const AdicionarTarefaScreen({Key? key}) : super(key: key);

  @override
  _AdicionarTarefaScreenState createState() => _AdicionarTarefaScreenState();
}

class _AdicionarTarefaScreenState extends State<AdicionarTarefaScreen> {
  final _formKey = GlobalKey<FormState>();
  Tarefa _novaTarefa = Tarefa(
    nome: '',
    descricao: '',
    tipo: 'Verificar pressão',
    frequencia: '2 vezes ao dia',
    diasSelecionados: List.filled(7, false),
    horario: TimeOfDay(hour: 20, minute: 0),
  );

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Salvar tarefa ou enviar para um serviço
      Navigator.of(context).pop(_novaTarefa);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adicionar Nova Tarefa')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Nome da Tarefa'),
              onChanged: (value) => setState(() => _novaTarefa.nome = value),
              validator: (value) => value?.isEmpty ?? true 
                ? 'Por favor, insira um nome' 
                : null,
            ),
            // Adicione mais campos de formulário conforme necessário
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Salvar Tarefa'),
            ),
          ],
        ),
      ),
    );
  }
}
