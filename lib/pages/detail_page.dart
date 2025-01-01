import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatelessWidget {
  final String noteTitle;
  final String noteDescription;
  final Color noteColor;
  final dynamic timestamp;

  const DetailPage({
    super.key,
    required this.noteTitle,
    required this.noteDescription,
    required this.noteColor,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final String formattedDate = _formatTimestamp(timestamp);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Details'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.black87,
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              noteTitle,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              noteDescription,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Created at: $formattedDate',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'Unknown date';
    try {
      DateTime dateTime = timestamp.toDate();
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } catch (e) {
      return 'Invalid date';
    }
  }
}
