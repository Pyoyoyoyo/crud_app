import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:crud_app/services/firestore_services.dart'; // Import the service

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController titleTextController = TextEditingController();
  final TextEditingController descriptionTextController =
      TextEditingController();

  void openNotebox(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration:
                  const InputDecoration(hintText: 'Enter your note here'),
              controller: titleTextController,
            ),
            TextField(
              decoration: const InputDecoration(
                  hintText: 'Enter your description here'),
              controller: descriptionTextController,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              firestoreService.addNote(
                titleTextController.text,
                descriptionTextController.text,
              );
              titleTextController.clear();
              descriptionTextController.clear();
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Color parseColor(String colorHex) {
    if (!colorHex.startsWith('0x')) {
      colorHex = '0x$colorHex';
    }
    return Color(int.parse(colorHex));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes App'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onPressed: () {
          openNotebox(context);
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = notesList[index];
                String docId = document.id;
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;

                String noteText = data['note'];
                Color noteColor = parseColor(data['color']);

                return Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: noteColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(noteText),
                    contentPadding: const EdgeInsets.all(10),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            DocumentSnapshot docSnapshot =
                                await firestoreService.getNoteById(docId);
                            Map<String, dynamic> noteData =
                                docSnapshot.data() as Map<String, dynamic>;

                            titleTextController.text = noteData['note'];
                            descriptionTextController.text =
                                noteData['description'];

                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      decoration: const InputDecoration(
                                          hintText: 'Edit your note here'),
                                      controller: titleTextController,
                                    ),
                                    TextField(
                                      decoration: const InputDecoration(
                                          hintText:
                                              'Edit your description here'),
                                      controller: descriptionTextController,
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      firestoreService.updateNote(
                                        docId,
                                        titleTextController.text,
                                        descriptionTextController.text,
                                      );
                                      titleTextController.clear();
                                      descriptionTextController.clear();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Update'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            firestoreService.deleteNote(docId);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Image(image: AssetImage('assets/images/empty.png')),
                SizedBox(height: 10),
                Text('No notes yet'),
              ],
            );
          }
        },
      ),
    );
  }
}
