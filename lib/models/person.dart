// model person

class PersonTask {
  final String personName;
  final String taskTitle;
  int count;

  PersonTask({
    required this.personName,
    required this.taskTitle,
    required this.count,
  });

  // Convert a PersonTask into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'personName': personName,
      'taskTitle': taskTitle,
      'count': count,
    };
  }

  // Extract a PersonTask object from a Map.
  static PersonTask fromMap(Map<String, dynamic> map) {
    return PersonTask(
      personName: map['personName'],
      taskTitle: map['taskTitle'],
      count: map['count'],
    );
  }
}
