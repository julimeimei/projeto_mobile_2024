/// Funções auxiliares para manipulação de tarefas.
///
/// Este arquivo contém utilitários que podem ser usados para transformar,
/// validar ou processar informações relacionadas às tarefas.

/// Retorna o número total de tarefas concluídas em uma lista.
int countCompletedTasks(List<Map<String, dynamic>> tasks) {
  return tasks.where((task) => task['completed'] == true).length;
}

/// Gera uma lista de IDs de tarefas pendentes.
List<int> getPendingTaskIds(List<Map<String, dynamic>> tasks) {
  return tasks
      .where((task) => task['completed'] == false)
      .map<int>((task) => task['id'] as int)
      .toList();
}

/// Valida se uma tarefa tem os campos obrigatórios.
bool isValidTask(Map<String, dynamic> task) {
  return task.containsKey('id') &&
      task.containsKey('title') &&
      task.containsKey('completed');
}
