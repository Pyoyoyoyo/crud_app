import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:crud_app/widgets/note_dialog.dart';
import 'package:crud_app/services/firestore_services.dart';

class NoteItem extends StatelessWidget {
  final DocumentSnapshot document;
  final FirestoreService firestoreService;

  const NoteItem({
    Key? key,
    required this.document,
    required this.firestoreService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String docId = document.id;
    final data = document.data() as Map<String, dynamic>;
    final String noteText = data['note'] ?? 'Untitled Note';
    final String description = data['description'] ?? 'No description';
    final Color noteColor = _parseColor(data['color']);

    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: noteColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          noteText,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(
            color: Colors.white60,
          ),
        ),
        contentPadding: const EdgeInsets.all(10),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              color: Colors.white60,
              onPressed: () {
                _openEditNoteDialog(context, docId, noteText, description);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.white60,
              onPressed: () {
                firestoreService.deleteNote(docId);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openEditNoteDialog(
      BuildContext context, String docId, String note, String description) {
    showDialog(
      context: context,
      builder: (context) => NoteDialog(
        initialTitle: note,
        initialDescription: description,
        onSave: (title, description) {
          firestoreService.updateNote(docId, title, description);
        },
      ),
    );
  }

  Color _parseColor(String colorHex) {
    if (!colorHex.startsWith('0x')) {
      colorHex = '0x$colorHex';
    }
    return Color(int.parse(colorHex));
  }
}
