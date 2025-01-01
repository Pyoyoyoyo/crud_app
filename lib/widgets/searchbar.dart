import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const SearchBar({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        onChanged: onChanged, // Pass typing events to parent widget
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
    );
  }
}
