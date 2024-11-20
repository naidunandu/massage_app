import 'package:flutter/material.dart';

class PositionedModel {
  final String id;
  final String color;
  Offset position;

  PositionedModel({
    required this.id,
    required this.color,
    required this.position,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'color': color,
      'position': {'dx': position.dx, 'dy': position.dy},
    };
  }

  factory PositionedModel.fromMap(Map<String, dynamic> map) {
    return PositionedModel(
      id: map['id'],
      color: map['color'],
      position: Offset(map['position']['dx'], map['position']['dy']),
    );
  }
}
