import 'package:flutter/material.dart';

class CircleObjectWidget extends StatelessWidget {
  final String color;
  final double size;
  const CircleObjectWidget({super.key, required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: color == "Green" ? Colors.green : Colors.redAccent,
          width: 2,
        ),
      ),
    );
  }
}
