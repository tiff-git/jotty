import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'note_widget.dart';

void main() {
  runApp(const MainApp());
  doWhenWindowReady(() {
    final initialSize = Size(300, 500);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF303446),
        scaffoldBackgroundColor: Color(0xFF232634),
        hintColor: Color(0xFF96CDFB),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFD9E0EE)),
          bodyMedium: TextStyle(color: Color(0xFFD9E0EE)),
        ),
      ),
      home: const NoteWidget(),
    );
  }
}