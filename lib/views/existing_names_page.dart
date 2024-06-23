import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repositories/task_repository.dart';
import '../widgets/bottom_nav_bar.dart';

class SaveFamilyName extends StatefulWidget {
  @override
  _SaveFamilyNameState createState() => _SaveFamilyNameState();
}

class _SaveFamilyNameState extends State<SaveFamilyName> {
  final TextEditingController _PersonNameController = TextEditingController(); // Controller for text input field
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Key for accessing Scaffold's state

  @override
  Widget build(BuildContext context) {
    final taskRepository = Provider.of<TaskRepository>(context); // Access the TaskRepository instance using Provider

    return Scaffold(
      key: _scaffoldKey, // Assign the scaffold key to Scaffold
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable the back button on the app bar
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold), // Title text style
              ),
              Text(
                ' Names',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo, // Text color
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _PersonNameController,
                  decoration: InputDecoration(
                    labelText: 'Add a new family member', // Input field label
                    border: OutlineInputBorder(), // Border around the input field
                  ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (_PersonNameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a member name')), // Show a snackbar if the input field is empty
                    );
                  } else {
                    await taskRepository.addnewPerson(_PersonNameController.text); // Add the new family member using the task repository
                    _PersonNameController.clear(); // Clear the text input field
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Member added successfully')), // Show a snackbar after successfully adding the member
                    );
                    setState(() {}); // Rebuild widget to show new member
                  }
                },
                child: Text('Add member'), // Button text
              ),
              SizedBox(height: 20),
              FutureBuilder<List<String>>(
                future: taskRepository.FindAllPerson(), // Fetch all family members from the task repository
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Show a loading indicator while fetching data
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}'); // Show an error message if fetching data fails
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No members found.'); // Display message if no family members are found
                  } else {
                    return Column(
                      children: snapshot.data!.map((personName) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                          child: Card(
                            elevation: 2, // Card elevation
                            child: ListTile(
                              title: Text(personName), // Family member name displayed in a list tile
                              trailing: IconButton(
                                icon: Icon(Icons.delete), // Delete icon button
                                onPressed: () async {
                                  await taskRepository.deletePerson(personName); // Delete family member from repository
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Member deleted successfully')), // Show a snackbar after deleting the member
                                  );
                                  setState(() {}); // Refresh the state to update the member list
                                },
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
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
