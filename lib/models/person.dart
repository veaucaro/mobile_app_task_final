class PersonTask {
  final String personName;    // The name of the person associated with the task
  final String taskTitle;     // The title or description of the task
  int count;                  // The count or number associated with the task

  PersonTask({
    required this.personName,
    required this.taskTitle,
    required this.count,
  });

  // Constructor for PersonTask class, which initializes the attributes:
  // - personName: Name of the person associated with the task (required)
  // - taskTitle: Title or description of the task (required)
  // - count: Count or number associated with the task (required)

  // Convert a PersonTask into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'personName': personName,   // Maps personName attribute to 'personName' key in the map
      'taskTitle': taskTitle,     // Maps taskTitle attribute to 'taskTitle' key in the map
      'count': count,             // Maps count attribute to 'count' key in the map
    };
  }

  // Extract a PersonTask object from a Map.
  static PersonTask fromMap(Map<String, dynamic> map) {
    return PersonTask(
      personName: map['personName'],   // Retrieves 'personName' value from the map
      taskTitle: map['taskTitle'],     // Retrieves 'taskTitle' value from the map
      count: map['count'],             // Retrieves 'count' value from the map
    );
  }
}
