import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/task_model.dart';
import 'tasks_screen.dart';

class CalendarScreen extends StatefulWidget {
  final UserModel user;
  final VoidCallback onLogout;

  const CalendarScreen({
    super.key,
    required this.user,
    required this.onLogout,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDate;
  late DateTime _focusedDate;
  final Map<DateTime, List<TaskModel>> _tasksByDate = {};

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _focusedDate = DateTime.now();
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  void _onTasksUpdated(List<TaskModel> tasks) {
    setState(() {
      final normalizedDate = _normalizeDate(_selectedDate);
      _tasksByDate[normalizedDate] = tasks;
    });
  }

  int _getTaskCountForDate(DateTime date) {
    final normalizedDate = _normalizeDate(date);
    return _tasksByDate[normalizedDate]?.length ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calendário de Tarefas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF7C3AED),
        elevation: 0,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Sair'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirmar Saída'),
                      content: const Text('Deseja sair da aplicação?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            widget.onLogout();
                          },
                          child: const Text(
                            'Sair',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
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
        child: Column(
          children: [
            // Informações do usuário
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xFF7C3AED),
                    child: Text(
                      widget.user.email[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bem-vindo!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          widget.user.email,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Calendário
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Cabeçalho do calendário
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.chevron_left),
                                onPressed: () {
                                  setState(() {
                                    _focusedDate = DateTime(
                                      _focusedDate.year,
                                      _focusedDate.month - 1,
                                    );
                                  });
                                },
                              ),
                              Text(
                                '${_getMonthName(_focusedDate.month)} ${_focusedDate.year}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF7C3AED),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.chevron_right),
                                onPressed: () {
                                  setState(() {
                                    _focusedDate = DateTime(
                                      _focusedDate.year,
                                      _focusedDate.month + 1,
                                    );
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Dias da semana
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab']
                                .map(
                                  (day) => Text(
                                    day,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 12),
                          // Dias do calendário
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              childAspectRatio: 1.2,
                            ),
                            itemCount: _getDaysInMonth(_focusedDate),
                            itemBuilder: (context, index) {
                              final firstDayOfMonth = DateTime(
                                _focusedDate.year,
                                _focusedDate.month,
                                1,
                              );
                              final firstWeekday = firstDayOfMonth.weekday % 7;
                              final day = index - firstWeekday + 1;

                              if (day <= 0 ||
                                  day > _getDaysInMonth(_focusedDate)) {
                                return const SizedBox();
                              }

                              final date = DateTime(
                                _focusedDate.year,
                                _focusedDate.month,
                                day,
                              );
                              final isSelected =
                                  _normalizeDate(date) ==
                                  _normalizeDate(_selectedDate);
                              final taskCount = _getTaskCountForDate(date);

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedDate = date;
                                  });
                                  _navigateToTasks();
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF7C3AED)
                                        : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                    border: isSelected
                                        ? Border.all(
                                            color: const Color(0xFF7C3AED),
                                            width: 2,
                                          )
                                        : null,
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '$day',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          if (taskCount > 0)
                                            Container(
                                              margin: const EdgeInsets.only(
                                                top: 4,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 6,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? Colors.white
                                                    : const Color(0xFF7C3AED),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                '$taskCount',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: isSelected
                                                      ? const Color(0xFF7C3AED)
                                                      : Colors.white,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Botão para ir para tarefas
                    ElevatedButton.icon(
                      onPressed: _navigateToTasks,
                      icon: const Icon(Icons.list),
                      label: Text(
                        'Ver Tarefas de ${_formatDate(_selectedDate)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C3AED),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToTasks() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TasksScreen(
          selectedDate: _selectedDate,
          onTasksUpdated: _onTasksUpdated,
          initialTasks: _tasksByDate[_normalizeDate(_selectedDate)] ?? [],
        ),
      ),
    );
  }

  int _getDaysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }

  String _getMonthName(int month) {
    const months = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ];
    return months[month - 1];
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
