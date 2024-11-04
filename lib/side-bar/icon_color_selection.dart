import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconColorSelectionDialog extends StatefulWidget {
  final Function(IconData, Color) onSelected;

  const IconColorSelectionDialog({required this.onSelected, Key? key}) : super(key: key);

  @override
  _IconColorSelectionDialogState createState() => _IconColorSelectionDialogState();
}

class _IconColorSelectionDialogState extends State<IconColorSelectionDialog> {
  IconData? selectedIcon;
  Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Icon and Color', style: TextStyle(color: Color(0xFFD9E0EE))),
      backgroundColor: Color(0xFF232634),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: 10,
            children: [
              _buildIconOption(FontAwesomeIcons.solidNoteSticky),
              _buildIconOption(FontAwesomeIcons.solidStar),
              _buildIconOption(FontAwesomeIcons.solidHeart),
              _buildIconOption(FontAwesomeIcons.solidLightbulb),
              _buildIconOption(FontAwesomeIcons.solidBell),
              _buildIconOption(FontAwesomeIcons.solidBookmark),
              // Add more icons as needed
            ],
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 10,
            children: [
              _buildColorOption(Color(0xFF96CDFB)), // Blue
              _buildColorOption(Color(0xFFABABF7)), // Purple
              _buildColorOption(Color(0xFFF5C2E7)), // Pink
              _buildColorOption(Color(0xFFF28FAD)), // Red
              _buildColorOption(Color(0xFFFAE3B0)), // Yellow
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (selectedIcon != null && selectedColor != null) {
              widget.onSelected(selectedIcon!, selectedColor!);
              Navigator.of(context).pop();
            }
          },
          child: Text('Add', style: TextStyle(color: Color(0xFFD9E0EE))),
        ),
      ],
    );
  }

  Widget _buildIconOption(IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIcon = icon;
        });
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: selectedIcon == icon ? Color(0xFF96CDFB).withOpacity(0.2) : Colors.transparent,
          border: selectedIcon == icon ? Border.all(color: Color(0xFF96CDFB), width: 2) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: FaIcon(icon, color: Color(0xFFD9E0EE)),
      ),
    );
  }

  Widget _buildColorOption(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: selectedColor == color ? Border.all(color: Colors.white, width: 2) : null,
        ),
      ),
    );
  }
}