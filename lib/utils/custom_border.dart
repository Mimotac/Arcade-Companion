import 'package:flutter/material.dart';

class CustomBorder extends ContinuousRectangleBorder {
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path path = Path();

    path.lineTo(0, rect.height * 1.15);

    path.cubicTo(0, rect.height * 1.1, 0, rect.height * 1.05, 0, rect.height);
    path.cubicTo(rect.width * 0.02, rect.height, rect.width * 0.05, rect.height,
        rect.width * 0.07, rect.height);
    path.cubicTo(rect.width * 0.05, rect.height * 1.05, rect.width * 0.02,
        rect.height * 1.1, 0, rect.height * 1.15);
    path.cubicTo(rect.width * 0.02, rect.height * 1.1, rect.width * 0.05,
        rect.height * 1.05, rect.width * 0.07, rect.height);
    path.cubicTo(rect.width * 0.05, rect.height, rect.width * 0.02, rect.height,
        0, rect.height);
    path.cubicTo(
        0, rect.height * 1.05, 0, rect.height * 1.1, 0, rect.height * 1.15);
    path.cubicTo(rect.width * 0.02, rect.height * 1.1, rect.width * 0.05,
        rect.height * 1.05, rect.width * 0.07, rect.height);
    path.cubicTo(rect.width * 0.05, rect.height, rect.width * 0.02, rect.height,
        0, rect.height);
    path.cubicTo(
        0, rect.height * 1.05, 0, rect.height * 1.1, 0, rect.height * 1.15);
    path.cubicTo(
        0, rect.height * 1.15, 0, rect.height * 1.15, 0, rect.height * 1.15);

    path.lineTo(0, 0);

    path.cubicTo(rect.width / 3, 0, rect.width * 0.67, 0, rect.width, 0);
    path.cubicTo(rect.width, rect.height / 3, rect.width, rect.height * 0.67,
        rect.width, rect.height);
    path.cubicTo(rect.width * 0.67, rect.height, rect.width / 3, rect.height, 0,
        rect.height);
    path.cubicTo(0, rect.height * 0.67, 0, rect.height / 3, 0, 0);
    path.cubicTo(0, 0, 0, 0, 0, 0);

    path.lineTo(rect.width * 0.93, rect.height);

    path.cubicTo(rect.width * 0.95, rect.height, rect.width * 0.98, rect.height,
        rect.width, rect.height);
    path.cubicTo(rect.width, rect.height * 1.05, rect.width, rect.height * 1.1,
        rect.width, rect.height * 1.15);
    path.cubicTo(rect.width * 0.98, rect.height * 1.1, rect.width * 0.95,
        rect.height * 1.05, rect.width * 0.93, rect.height);
    path.cubicTo(rect.width * 0.93, rect.height, rect.width * 0.93, rect.height,
        rect.width * 0.93, rect.height);

    return path;
  }
}
