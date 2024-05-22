import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Data extends Equatable {
  final int index;
  final double top;
  final double left;
  final int angleInDegrees;
  final MaterialColor color;

  Data({
    required this.index,
    required this.top,
    required this.left,
    required this.angleInDegrees,
    required this.color,
  });

  Data copyWith({
    int? index,
    double? top,
    double? left,
    int? angleInDegrees,
  }) {
    return Data(
      index: index ?? this.index,
      top: top ?? this.top,
      left: left ?? this.left,
      angleInDegrees: angleInDegrees ?? this.angleInDegrees,
      color: color,
    );
  }

  @override
  String toString() {
    return 'INDEX: $index, TOP: $top, LEFT: $left, ANGLE: $angleInDegrees';
  }

  @override
  List<Object?> get props => [top, left, angleInDegrees, index];
}
