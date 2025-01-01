import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:crud_app/services/firestore_services.dart';
import 'package:crud_app/widgets/empty_state.dart';
import 'package:crud_app/widgets/note_item.dart';
import 'package:crud_app/widgets/note_dialog.dart';

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const HomePage({super.key, required this.toggleTheme});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes App'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
        onPressed: () {
          _openAddNoteDialog(context);
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Customized SearchBar
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search notes...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.black45,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                ),
              ),
            ),
            // Notes List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestoreService.getNotesStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const EmptyState();
                  }

                  final notesList = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final title = (data['note'] ?? '').toString().toLowerCase();
                    return title.contains(searchQuery);
                  }).toList();

                  return ListView.builder(
                    itemCount: notesList.length,
                    itemBuilder: (context, index) {
                      return NoteItem(
                        document: notesList[index],
                        firestoreService: firestoreService,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openAddNoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => NoteDialog(
        onSave: (title, description) {
          firestoreService.addNote(
            title,
            description,
          );
        },
      ),
    );
  }
}
