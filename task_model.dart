class TaskModel {
  final String id;
  final String title;
  final DateTime date;
  bool isCompleted;

  TaskModel({
    required this.id,
    required this.title,
    required this.date,
    this.isCompleted = false,
  });

  // Método para criar uma cópia com alterações
  TaskModel copyWith({
    String? id,
    String? title,
    DateTime? date,
    bool? isCompleted,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
