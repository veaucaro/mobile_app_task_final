import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repositories/task_repository.dart';
import '../widgets/bottom_nav_bar.dart';

class SaveFamilyName extends StatefulWidget {
  @override
  _SaveFamilyNameState createState() => _SaveFamilyNameState();
}

class _SaveFamilyNameState extends State<SaveFamilyName> {
  final TextEditingController _PersonNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final taskRepository = Provider.of<TaskRepository>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Family name'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _PersonNameController,
                  decoration: InputDecoration(
                    labelText: 'Add a new family member',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (_PersonNameController.text.isNotEmpty) {
                    await taskRepository.addnewPerson(_PersonNameController.text);
                    _PersonNameController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('member added successfully')),
                    );
                    (context as Element).reassemble();
                  }
                },
                child: Text('Add member'),
              ),
              SizedBox(height: 20),
              FutureBuilder<List<String>>(
                future: taskRepository.FindAllPerson(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No members found.');
                  } else {
                    return Column(
                      children: snapshot.data!.map((personName) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                          child: Card(
                            elevation: 2,
                            child: ListTile(
                              title: Text(personName),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  await taskRepository.deletePerson(personName);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Member deleted successfully')),
                                  );
                                  setState(() {});
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
