import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:crud_app/services/firestore_services.dart';
import 'package:crud_app/widgets/empty_state.dart';
import 'package:crud_app/widgets/note_item.dart';
import 'package:crud_app/widgets/note_dialog.dart';

class HomePage extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes App'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
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
        child: StreamBuilder<QuerySnapshot>(
          stream: firestoreService.getNotesStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const EmptyState();
            }

            final notesList = snapshot.data!.docs;

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
