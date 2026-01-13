import 'package:flutter/material.dart';

class DropdownSelectedColor extends StatefulWidget {
  Function(MaterialColor, String)? onColorSelected;
  DropdownSelectedColor({super.key, this.onColorSelected});

  @override
  State<DropdownSelectedColor> createState() => _DropdownSelectedColorState();
}

class _DropdownSelectedColorState extends State<DropdownSelectedColor> {
  MaterialColor selectedColor = Colors.grey;
  String selectedColorCode = '#9E9E9E';

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        {"color": Colors.red, "colorcode": "#F44336"},
        {"color": Colors.pink, "colorcode": "#E91E63"},
        {"color": Colors.purple, "colorcode": "#9C27B0"},
        {"color": Colors.deepPurple, "colorcode": "#673AB7"},
        {"color": Colors.indigo, "colorcode": "#3F51B5"},
        {"color": Colors.blue, "colorcode": "#2196F3"},
        {"color": Colors.lightBlue, "colorcode": "#03A9F4"},
        {"color": Colors.cyan, "colorcode": "#00BCD4"},
        {"color": Colors.teal, "colorcode": "#009688"},
        {"color": Colors.green, "colorcode": "#4CAF50"},
        {"color": Colors.lightGreen, "colorcode": "#8BC34A"},
        {"color": Colors.lime, "colorcode": "#CDDC39"},
        {"color": Colors.yellow, "colorcode": "#FFEB3B"},
        {"color": Colors.amber, "colorcode": "#FFC107"},
        {"color": Colors.orange, "colorcode": "#FF9800"},
        {"color": Colors.deepOrange, "colorcode": "#FF5722"},
        {"color": Colors.brown, "colorcode": "#795548"},
        {"color": Colors.grey, "colorcode": "#9E9E9E"},
        {"color": Colors.blueGrey, "colorcode": "#607D8B"},
      ].map((color) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedColor = color["color"] as MaterialColor;
              selectedColorCode = color["colorcode"] as String;
            widget.onColorSelected?.call(
                color["color"] as MaterialColor, color["colorcode"] as String);
            });
          },
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color["color"] as MaterialColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: selectedColor == color['color'] ? Colors.black : Colors.grey,
                width: selectedColor == color['color'] ? 3 : 1,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
