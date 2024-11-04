import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'icon_color_selection.dart';

class Sidebar extends StatefulWidget {
  final Function(int) onTabSelected;
  final Function onTabAdded;

  const Sidebar({required this.onTabSelected, required this.onTabAdded, Key? key}) : super(key: key);

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  List<Map<String, dynamic>> noteIcons = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      color: Color(0xFF303446),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: noteIcons.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: () => _showDeleteConfirmationDialog(index),
                  child: IconButton(
                    icon: FaIcon(noteIcons[index]['icon'], color: noteIcons[index]['color']),
                    onPressed: () {
                      widget.onTabSelected(index);
                    },
                  ),
                );
              },
            ),
          ),
          IconButton(
            icon: FaIcon(FontAwesomeIcons.plus, color: Color(0xFFD9E0EE)),
            onPressed: _showIconSelectionDialog,
          ),
        ],
      ),
    );
  }

  void _showIconSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return IconColorSelectionDialog(
          onSelected: (icon, color) {
            setState(() {
              noteIcons.add({'icon': icon, 'color': color});
              widget.onTabAdded();
            });
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Jot', style: TextStyle(color: Color(0xFFD9E0EE))),
          backgroundColor: Color(0xFF232634),
          content: Text('Are you sure you want to delete this jot?', style: TextStyle(color: Color(0xFFD9E0EE))),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Color(0xFFD9E0EE))),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  noteIcons.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: Text('Delete', style: TextStyle(color: Color(0xFFD9E0EE))),
            ),
          ],
        );
      },
    );
  }
}