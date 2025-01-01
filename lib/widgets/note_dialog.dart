import 'package:flutter/material.dart';

class NoteDialog extends StatelessWidget {
  final String? initialTitle;
  final String? initialDescription;
  final void Function(String title, String description) onSave;

  const NoteDialog({
    Key? key,
    this.initialTitle,
    this.initialDescription,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController =
        TextEditingController(text: initialTitle);
    final TextEditingController descriptionController =
        TextEditingController(text: initialDescription);

    return AlertDialog(
      backgroundColor: Colors.black87,
      title: Text(
        initialTitle == null ? 'Add Note' : 'Edit Note',
        style: TextStyle(color: Colors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTextField(
            controller: titleController,
            hint: 'Enter your note title',
          ),
          const SizedBox(height: 10),
          _buildTextField(
            controller: descriptionController,
            hint: 'Enter your note description',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            onSave(
              titleController.text,
              descriptionController.text,
            );
            Navigator.of(context).pop();
          },
          child: Text(
            initialTitle == null ? 'Add' : 'Update',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
