import 'package:flutter/material.dart';

class AdicionarTarefaScreen extends StatefulWidget {
  const AdicionarTarefaScreen({Key? key}) : super(key: key);

  @override
  State<AdicionarTarefaScreen> createState() => _AdicionarTarefaScreenState();
}

class _AdicionarTarefaScreenState extends State<AdicionarTarefaScreen> {
  final _formKey = GlobalKey<FormState>();
  String _nome = '';
  String _descricao = '';
  String _tarefaSelecionada = 'Verificar pressão'; // Valor inicial
  String _frequenciaSelecionada = '2 vezes ao dia'; // Valor inicial
  List<bool> _diasSelecionados = [false, false, false, false, false, false, false];
  TimeOfDay _horario = TimeOfDay(hour: 20, minute: 0); // Valor inicial