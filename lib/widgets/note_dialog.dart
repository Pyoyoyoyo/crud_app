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
      title: Text(initialTitle == null ? 'Add Note' : 'Edit Note'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTextField(
            controller: titleController,
            hint: 'Enter your note title',
          ),
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
          child: Text(initialTitle == null ? 'Add' : 'Update'),
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
      decoration: InputDecoration(hintText: hint),
    );
  }
}
