import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'side-bar/sidebar.dart';
import 'drawing_painter.dart';
import 'search_dialog.dart';

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
  List<String> filteredNotes = [];
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _controller.text = notes[selectedIndex];
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
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
      _confettiController.play();
    });
  }

  void _onNoteIconsChanged(List<Map<String, dynamic>> updatedNoteIcons) {
    setState(() {
      // Update the notes list based on the new order of note icons
      List<String> newNotes = List<String>.filled(updatedNoteIcons.length, '', growable: true);
      List<List<Offset?>> newDrawings = List<List<Offset?>>.filled(updatedNoteIcons.length, [], growable: true);
      for (int i = 0; i < updatedNoteIcons.length; i++) {
        int? oldIndex = updatedNoteIcons[i]['index'];
        if (oldIndex != null && oldIndex >= 0 && oldIndex < notes.length) {
          newNotes[i] = notes[oldIndex];
          newDrawings[i] = drawings[oldIndex];
        }
      }
      notes = newNotes;
      drawings = newDrawings;

      // Ensure selectedIndex is within the valid range
      if (notes.isEmpty) {
        notes.add('');
        drawings.add([]);
        selectedIndex = 0;
      } else if (selectedIndex >= notes.length) {
        selectedIndex = notes.length - 1;
      }
      _updateControllerText();
    });
  }

  void _toggleDrawMode() {
    setState(() {
      isDrawMode = !isDrawMode;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      filteredNotes = notes.where((note) => note.contains(query)).toList();
    });
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SearchDialog(onSearch: _onSearchChanged);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF303446),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Row(
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
                      child: Column(
                        children: [
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
                                      hintText: 'Start Jotting...',
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
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      icon: Icon(Icons.search, color: Color(0xFFD9E0EE)),
                                      onPressed: _showSearchDialog,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 3.14 / 2, // downwards
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.1,
              minimumSize: const Size(5, 5), // set the minimum size of the confetti
              maximumSize: const Size(10, 10), // set the maximum size of the confetti
              colors: const [ // set the colors for the confetti
                Color(0xFFF4B8E4),
                Color(0xFFF4B8E4),
                Color(0xFFF4B8E4),
                Color(0xFFF4B8E4),
                Color(0xFFF4B8E4),
                Color(0xFFF4B8E4),
              ],
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

    canvas.drawLine(Offset(0, 0), Offset(size.width, 0), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}