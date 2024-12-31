import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');

  Future<void> addNote(String note, String description) {
    Color randomColor =
        Colors.primaries[Random().nextInt(Colors.primaries.length)];
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
      'color':
          randomColor.value.toRadixString(16).padLeft(8, '0'), // Store full hex
      'description': description,
    });
  }

  Stream<QuerySnapshot> getNotesStream() {
    return notes.orderBy('timestamp', descending: true).snapshots();
  }

  Future<DocumentSnapshot> getNoteById(String docId) {
    return notes.doc(docId).get();
  }

  Future<void> updateNote(String docId, String note, String description) {
    return notes.doc(docId).update({
      'note': note,
      'timestamp': Timestamp.now(),
      'description': description,
    });
  }

  Future<void> deleteNote(String docId) {
    return notes.doc(docId).delete();
  }
}
