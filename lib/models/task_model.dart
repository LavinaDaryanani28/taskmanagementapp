class TaskModel {
  final String id;
  late String taskName; // Required
  late String category; // Required
  late String? description; // Optional
  late DateTime? dueDate; // Optional
  late bool isCompleted; // Tracks task completion status

  TaskModel({
    required this.id,
    required this.taskName,
    required this.category,
    this.description,
    this.dueDate,
    this.isCompleted = false, // Default to false
  });

  // Factory constructor to create a TaskModel instance from JSON
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      taskName: json['taskName'] as String,
      category: json['category'] as String,
      description: json['description'] as String?, // Nullable field
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null, // Nullable field
      isCompleted: json['isCompleted'] as bool? ?? false, // Default to false if null
    );
  }

  // Method to convert a TaskModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskName': taskName,
      'category': category,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  // Method to create a copy of the task with updated fields
  TaskModel copyWith({
    String? id,
    String? taskName,
    String? category,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return TaskModel(
      id: id ?? this.id,
      taskName: taskName ?? this.taskName,
      category: category ?? this.category,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
