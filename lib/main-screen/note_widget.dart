import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import '../side-bar/sidebar.dart';
import 'drawing_painter.dart';

class NoteWidget extends StatefulWidget {
  const NoteWidget({super.key});

  @override
  _NoteWidgetState createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  List<String> notes = [''];
  List<Map<String, dynamic>> noteIcons = [];
  List<List<Offset?>> drawings = [[]];
  int selectedIndex = 0;
  TextEditingController _controller = TextEditingController();
  bool isDrawMode = false;

  @override
  void initState() {
    super.initState();
    _controller.text = notes[selectedIndex];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateControllerText() {
    _controller.text = notes[selectedIndex];
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  void _onTabSelected(int index) {
    setState(() {
      selectedIndex = index;
      _updateControllerText();
    });
  }

  void _onTabAdded() {
    setState(() {
      notes.add('');
      drawings.add([]);
      selectedIndex = notes.length - 1;
      _updateControllerText();
    });
  }

  void _onNoteIconsChanged(List<Map<String, dynamic>> updatedNoteIcons) {
    setState(() {
      // Update the notes list based on the new order of note icons
      List<String> newNotes = List<String>.filled(updatedNoteIcons.length, '', growable: true);
      List<List<Offset?>> newDrawings = List<List<Offset?>>.filled(updatedNoteIcons.length, [], growable: true);
      for (int i = 0; i < updatedNoteIcons.length; i++) {
        int oldIndex = noteIcons.indexOf(updatedNoteIcons[i]);
        if (oldIndex != -1) {
          newNotes[i] = notes[oldIndex];
          newDrawings[i] = drawings[oldIndex];
        }
      }
      notes = newNotes;
      drawings = newDrawings;
      noteIcons = updatedNoteIcons;
      _updateControllerText();
    });
  }

  void _toggleDrawMode() {
    setState(() {
      isDrawMode = !isDrawMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF303446),
      body: Row(
        children: [
          Sidebar(
            onTabSelected: _onTabSelected,
            onTabAdded: _onTabAdded,
            onNoteIconsChanged: _onNoteIconsChanged,
            onDrawModeToggled: _toggleDrawMode,
          ),
          CustomPaint(
            size: Size(1, double.infinity),
            painter: ThinWhiteLinePainter(),
          ),
          Expanded(
            child: WindowBorder(
              color: Colors.transparent,
              width: 0,
              child: Column(
                children: [
                  WindowTitleBarBox(
                    child: Row(
                      children: [
                        Expanded(child: MoveWindow()),
                        const WindowButtons(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Stack(
                        children: [
                          TextField(
                            controller: _controller,
                            onChanged: (value) {
                              setState(() {
                                notes[selectedIndex] = value;
                              });
                            },
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: 'Enter your notes here...',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Color(0xFFD9E0EE)),
                            ),
                            style: TextStyle(color: Color(0xFFD9E0EE)),
                          ),
                          if (isDrawMode)
                            ClipRect(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return GestureDetector(
                                    onPanUpdate: (details) {
                                      setState(() {
                                        RenderBox renderBox = context.findRenderObject() as RenderBox;
                                        Offset localPosition = renderBox.globalToLocal(details.globalPosition);
                                        // Ensure the drawing does not go past the white line
                                        if (localPosition.dx > 1 && localPosition.dx < constraints.maxWidth) {
                                          drawings[selectedIndex].add(localPosition);
                                        }
                                      });
                                    },
                                    onPanEnd: (details) {
                                      drawings[selectedIndex].add(null);
                                    },
                                    child: CustomPaint(
                                      painter: DrawingPainter(drawings[selectedIndex]),
                                      child: Container(),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ThinWhiteLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1;

    canvas.drawLine(Offset(0, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(),
        CloseWindowButton(),
      ],
    );
  }
}