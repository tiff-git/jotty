import 'package:flutter/material.dart';

class SearchDialog extends StatelessWidget {
  final Function(String) onSearch;

  const SearchDialog({required this.onSearch, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _searchController = TextEditingController();

    return AlertDialog(
      backgroundColor: Color(0xFF303446),
      title: Text(
        'Search Notes',
        style: TextStyle(color: Color(0xFFD9E0EE)),
      ),
      content: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Enter search query...',
          hintStyle: TextStyle(color: Color(0xFFD9E0EE)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Color(0xFF3E4451),
        ),
        style: TextStyle(color: Color(0xFFD9E0EE)),
      ),
      actions: [
        TextButton(
          onPressed: () {
            onSearch(_searchController.text);
            Navigator.of(context).pop();
          },
          child: Text(
            'Search',
            style: TextStyle(color: Color(0xFFB5E8E0)),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: Color(0xFFB5E8E0)),
          ),
        ),
      ],
    );
  }
}