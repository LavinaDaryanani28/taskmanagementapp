class Task {
  String name;
  String description;
  String category;

  Task({
    required this.name,
    required this.description,
    required this.category,
  });

  // Convert a Task to a map so it can be stored in SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
    };
  }

  // Convert a map into a Task
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      name: map['name'],
      description: map['description'],
      category: map['category'],
    );
  }
}
