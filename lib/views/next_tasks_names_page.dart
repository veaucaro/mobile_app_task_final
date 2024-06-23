import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../repositories/task_repository.dart';
import '../widgets/bottom_nav_bar.dart';

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  late Future<List<String>> _personsFuture; // Future for fetching persons
  List<String> _persons = []; // List to store fetched persons

  @override
  void initState() {
    super.initState();
    _personsFuture = _fetchPersons(); // Initialize _personsFuture in initState
  }

  // Method to fetch persons from the repository
  Future<List<String>> _fetchPersons() async {
    try {
      final persons = await Provider.of<TaskRepository>(context, listen: false).FindAllPerson();
      return persons; // Return the fetched persons
    } catch (e) {
      print('Error loading persons: $e'); // Handle error if fetching persons fails
      return []; // Return an empty list in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context); // Access TaskProvider

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable back button on app bar
        actions: [
          IconButton(
            icon: Icon(Icons.select_all, size: 30),
            onPressed: () {
              if (taskProvider.selectedPerson.length == _persons.length) {
                taskProvider.clearAllPerson(); // Clear all selected persons if all are selected
              } else {
                taskProvider.selectAllPerson(_persons); // Select all persons
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Select your',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Text(
                  ' Family members',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            FutureBuilder<List<String>>(
              future: _personsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Show loading indicator while fetching persons
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // Display error message if fetching fails
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Column(
                    children: [
                      Text('No family members found.'), // Display message if no family members are found
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/profiles'); // Navigate to add member page
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.deepPurple,
                        ),
                        child: Text('Add Member'),
                      ),
                    ],
                  );
                } else {
                  _persons = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: _persons.length,
                      itemBuilder: (context, index) {
                        final person = _persons[index];
                        return CheckboxListTile(
                          title: Text(person),
                          value: taskProvider.isSelectedP(person),
                          onChanged: (value) {
                            taskProvider.toggleSelectionP(person); // Toggle person selection
                          },
                        );
                      },
                    ),
                  );
                }
              },
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_persons.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('No family members found.'), // Show snackbar if no family members are found
                        ),
                      );
                    } else if (taskProvider.selectedPerson.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please select at least one person.'), // Show snackbar if no persons are selected
                        ),
                      );
                    } else {
                      Navigator.pushNamed(context, '/page3'); // Navigate to next page
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: Text('Next ->'),
                ),
              ),
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
