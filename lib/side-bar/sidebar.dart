import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'icon_color_selection.dart';

class Sidebar extends StatefulWidget {
  final Function(int) onTabSelected;
  final Function onTabAdded;
  final Function(List<Map<String, dynamic>>) onNoteIconsChanged;
  final Function onDrawModeToggled;

  const Sidebar({
    required this.onTabSelected,
    required this.onTabAdded,
    required this.onNoteIconsChanged,
    required this.onDrawModeToggled,
    Key? key,
  }) : super(key: key);

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  List<Map<String, dynamic>> noteIcons = [];

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

  void _onDeleteTab() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF303446),
          title: Text(
            'Delete Note',
            style: TextStyle(color: Color(0xFFD9E0EE)),
          ),
          content: Text(
            'Are you sure you want to delete this note?',
            style: TextStyle(color: Color(0xFFD9E0EE)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Color(0xFFB5E8E0)),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (noteIcons.isNotEmpty) {
                    int currentIndex = noteIcons.length - 1;
                    noteIcons.removeAt(currentIndex);
                    widget.onNoteIconsChanged(noteIcons);
                    widget.onTabSelected(currentIndex > 0 ? currentIndex - 1 : 0);
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Color(0xFFB5E8E0)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 60,
          color: Color(0xFF303446),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ReorderableListView(
                  onReorder: _onReorder,
                  buildDefaultDragHandles: false,
                  proxyDecorator: (Widget child, int index, Animation<double> animation) {
                    return Material(
                      color: Colors.transparent,
                      child: child,
                    );
                  },
                  children: [
                    for (int index = 0; index < noteIcons.length; index++)
                      Container(
                        key: ValueKey(noteIcons[index]),
                        child: ReorderableDragStartListener(
                          index: index,
                          child: IconButton(
                            icon: FaIcon(noteIcons[index]['icon'], color: noteIcons[index]['color']),
                            onPressed: () {
                              widget.onTabSelected(index);
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: FaIcon(FontAwesomeIcons.pen, color: Color(0xFFD9E0EE)),
                onPressed: () {
                  widget.onDrawModeToggled();
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Color(0xFFD9E0EE)),
                onPressed: _onDeleteTab,
              ),
              IconButton(
                icon: FaIcon(FontAwesomeIcons.plus, color: Color(0xFFD9E0EE)),
                onPressed: _showIconSelectionDialog,
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Container(
            width: 1,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = noteIcons.removeAt(oldIndex);
      noteIcons.insert(newIndex, item);
      widget.onNoteIconsChanged(noteIcons);
    });
  }
}