import 'package:flutter/material.dart';

class SwitcherWidget extends StatefulWidget {
  final List<String> colors;
  final String selectedColor;
  final Function(String) onTabSelect;
  const SwitcherWidget({
    super.key,
    required this.selectedColor,
    required this.onTabSelect,
    required this.colors,
  });

  @override
  State<SwitcherWidget> createState() => _SwitcherWidgetState();
}

class _SwitcherWidgetState extends State<SwitcherWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...widget.colors.map(
            (color) {
              return InkWell(
                onTap: () => widget.onTabSelect(color),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: widget.selectedColor == "Green" && color == "Green"
                        ? Colors.green
                        : widget.selectedColor == "Red" && color == "Red"
                            ? Colors.redAccent
                            : Colors.white,
                  ),
                  child: Text(
                    color,
                    style: TextStyle(
                      color: widget.selectedColor == color ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
