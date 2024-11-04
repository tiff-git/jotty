import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'side-bar/sidebar.dart';

class NoteWidget extends StatefulWidget {
  const NoteWidget({super.key});

  @override
  _NoteWidgetState createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  List<String> notes = [''];
  int selectedIndex = 0;
  TextEditingController _controller = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF303446),
      body: Row(
        children: [
          Sidebar(
            onTabSelected: (index) {
              setState(() {
                selectedIndex = index;
                _updateControllerText();
              });
            },
            onTabAdded: () {
              setState(() {
                notes.add('');
                selectedIndex = notes.length - 1;
                _updateControllerText();
              });
            },
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
                      child: TextField(
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
      ..strokeWidth = 2; // Increase the stroke width to make it bold

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