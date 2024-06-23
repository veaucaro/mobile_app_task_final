import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../providers/task_provider.dart';
import '../widgets/bottom_nav_bar.dart';

class Page3 extends StatefulWidget {
  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  late List<bool> _cardFlipped; // List to track flipped card state
  late List<String> _assignedPersons; // List to store assigned persons to tasks

  @override
  void initState() {
    super.initState();
    _cardFlipped = []; // Initialize _cardFlipped list
    _assignedPersons = []; // Initialize _assignedPersons list
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final taskProvider = Provider.of<TaskProvider>(context);
    _cardFlipped = List<bool>.filled(taskProvider.selectedTasks.length, false); // Initialize _cardFlipped with false values
    _assignedPersons = _assignPersonsToTasks(taskProvider.selectedTasks, taskProvider.selectedPerson); // Assign persons to tasks
  }

  // Function to assign persons to tasks ensuring no duplicates
  List<String> _assignPersonsToTasks(List<String> tasks, List<String> persons) {
    if (_assignedPersons.isNotEmpty) {
      return _assignedPersons; // Return existing assignments if already populated
    }

    List<String> assignedPersons = [];
    final shuffledPersons = [...persons];
    shuffledPersons.shuffle(); // Shuffle persons list

    for (int i = 0; i < tasks.length; i++) {
      assignedPersons.add(shuffledPersons[i % shuffledPersons.length]); // Assign persons cyclically to tasks
    }

    _assignedPersons = assignedPersons; // Store assignments in _assignedPersons
    return assignedPersons;
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    if (_assignedPersons.isEmpty) {
      return Center(child: CircularProgressIndicator()); // Show loading indicator if assigned persons list is empty
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable back button on app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Task',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              'Distribution',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: taskProvider.selectedTasks.length,
                itemBuilder: (context, index) {
                  final task = taskProvider.selectedTasks[index];
                  final person = _assignedPersons[index];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (!_cardFlipped[index]) {
                          _cardFlipped[index] = true; // Flip card if it's not flipped
                        }
                      });
                    },
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        final rotate = Tween(begin: pi, end: 0.0).animate(animation); // Animation for card flipping
                        return AnimatedBuilder(
                          animation: rotate,
                          child: child,
                          builder: (context, child) {
                            final isFront = rotate.value < pi / 2;
                            final angle = isFront ? rotate.value : pi - rotate.value;
                            return Transform(
                              transform: Matrix4.rotationY(angle),
                              alignment: Alignment.center,
                              child: isFront ? child! : Transform(
                                transform: Matrix4.rotationY(pi),
                                alignment: Alignment.center,
                                child: child,
                              ),
                            );
                          },
                        );
                      },
                      child: _cardFlipped[index]
                          ? Card(
                        key: ValueKey(true),
                        color: Colors.yellow[100],
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                task,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Assigned to:',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                person,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                              ),
                            ],
                          ),
                        ),
                      )
                          : Card(
                        key: ValueKey(false),
                        color: Colors.deepPurple,
                        child: Center(
                          child: Text(
                            'Tap to Reveal',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _assignedPersons = _assignPersonsToTasks(taskProvider.selectedTasks, taskProvider.selectedPerson); // Refresh assignments
                      _cardFlipped = List<bool>.filled(taskProvider.selectedTasks.length, false); // Reset flipped cards
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    shape: CircleBorder(), // Set button shape to circle
                    padding: EdgeInsets.all(10),
                  ),
                  icon: Icon(Icons.refresh, size: 24),
                  label: Text(''),
                ),
                ElevatedButton(
                  onPressed: () {
                    for (int i = 0; i < _cardFlipped.length; i++) {
                      if (_cardFlipped[i]) {
                        final task = taskProvider.selectedTasks[i];
                        final person = _assignedPersons[i];
                        taskProvider.updateTaskPersonMappingInDatabase(task, person); // Update task-person mapping in database
                      }
                    }
                    Navigator.pushNamed(context, '/accomplished_tasks'); // Navigate to accomplished tasks page
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                  ),
                  child: Text('Check accomplished tasks ->'),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/');
              break;
            case 1:
              Navigator.pushNamed(context, '/save_task_name');
              break;
            case 2:
              Navigator.pushNamed(context, '/profiles');
              break;
          }
        },
      ),
    );
  }
}
