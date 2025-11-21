import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TasksScreen extends StatefulWidget {
  final DateTime selectedDate;
  final Function(List<TaskModel>) onTasksUpdated;
  final List<TaskModel> initialTasks;

  const TasksScreen({
    super.key,
    required this.selectedDate,
    required this.onTasksUpdated,
    required this.initialTasks,
  });

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late List<TaskModel> _tasks;
  final _taskTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tasks = List.from(widget.initialTasks);
    _sortTasks();
  }

  @override
  void dispose() {
    _taskTitleController.dispose();
    super.dispose();
  }

  void _sortTasks() {
    // Primeiro, separa tarefas pendentes e concluídas
    final pendingTasks =
        _tasks.where((task) => !task.isCompleted).toList();
    final completedTasks = _tasks.where((task) => task.isCompleted).toList();

    // Ordena cada grupo alfabeticamente
    pendingTasks.sort((a, b) => a.title.compareTo(b.title));
    completedTasks.sort((a, b) => a.title.compareTo(b.title));

    // Combina: pendentes primeiro, depois concluídas
    _tasks = [...pendingTasks, ...completedTasks];
  }

  void _addTask() {
    final title = _taskTitleController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira um título para a tarefa'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _tasks.add(
        TaskModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          date: widget.selectedDate,
          isCompleted: false,
        ),
      );
      _sortTasks();
      _taskTitleController.clear();
    });

    widget.onTasksUpdated(_tasks);
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index] = _tasks[index].copyWith(
        isCompleted: !_tasks[index].isCompleted,
      );
      _sortTasks();
    });

    widget.onTasksUpdated(_tasks);
  }

  void _removeTask(int index) {
    final removedTask = _tasks[index];

    setState(() {
      _tasks.removeAt(index);
    });

    widget.onTasksUpdated(_tasks);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tarefa "${removedTask.title}" removida'),
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            setState(() {
              _tasks.add(removedTask);
              _sortTasks();
            });
            widget.onTasksUpdated(_tasks);
          },
        ),
      ),
    );
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Tarefa'),
        content: TextField(
          controller: _taskTitleController,
          decoration: InputDecoration(
            hintText: 'Digite o título da tarefa',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF7C3AED),
                width: 2,
              ),
            ),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              _taskTitleController.clear();
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              _addTask();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C3AED),
            ),
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tarefas - ${_formatDate(widget.selectedDate)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF7C3AED),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF7C3AED).withValues(alpha: 0.1),
              Colors.white,
            ],
          ),
        ),
        child: _tasks.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 80,
                      color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhuma tarefa para este dia',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Clique no botão + para adicionar uma tarefa',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  final isCompleted = task.isCompleted;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: GestureDetector(
                        onTap: () => _toggleTaskCompletion(index),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isCompleted
                                  ? const Color(0xFF7C3AED)
                                  : Colors.grey[300]!,
                              width: 2,
                            ),
                            color: isCompleted
                                ? const Color(0xFF7C3AED)
                                : Colors.transparent,
                          ),
                          child: isCompleted
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20,
                                )
                              : null,
                        ),
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isCompleted ? Colors.grey[400] : Colors.black,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () => _removeTask(index),
                      ),
                      onTap: () => _toggleTaskCompletion(index),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: const Color(0xFF7C3AED),
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const days = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab'];
    const months = [
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Mai',
      'Jun',
      'Jul',
      'Ago',
      'Set',
      'Out',
      'Nov',
      'Dez'
    ];

    return '${days[date.weekday % 7]}, ${date.day} de ${months[date.month - 1]}';
  }
}
