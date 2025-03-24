import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChartItem<T> {
  final T identifier;
  final Color color;
  final double value;

  ChartItem({
    required this.identifier,
    required this.color,
    required this.value,
  });
}

class ChartWidget extends StatelessWidget {
  final List<ChartItem> items;
  final double? maxValue;

  const ChartWidget({super.key, required this.items, this.maxValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red.withOpacity(0.1),
      child: CustomPaint(
        painter: ChartPainter(items: items, totalValue: maxValue),
      ),
    );
  }
}

class ChartPainter extends CustomPainter {
  final List<ChartItem> items;
  final double? totalValue;
  static const double spacing = 2.0;

  ChartPainter({required this.items, this.totalValue});

  final horizontalSkew = 10.0;
  final verticalSkew = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    final twoDSize = Size(
      size.width - horizontalSkew,
      size.height - verticalSkew,
    );

    final total =
        totalValue ?? items.fold<double>(0.0, (sum, item) => sum + item.value);
    final maxHeight = twoDSize.height - verticalSkew;
    final availableWidth =
        twoDSize.width - (items.length + 1) * spacing - horizontalSkew;

    var xOffset = spacing;

    // Draw bars from left to right
    for (var i = 0; i < items.length; i++) {
      final item = items[i];

      // Calculate width based on value
      final barWidth = (item.value / total) * availableWidth;

      // Draw the bar
      final rect = Rect.fromLTWH(xOffset, verticalSkew, barWidth, maxHeight);

      // Fill the bar
      canvas.drawRect(
        rect,
        Paint()
          ..color = item.color
          ..style = PaintingStyle.fill,
      );

      // Draw black border
      canvas.drawRect(
        rect,
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0,
      );

      canvas.drawParallelogram(
        rect: rect,
        skew: -horizontalSkew,
        paint:
            Paint()
              ..color = Colors.black
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.0,
      );
      canvas.drawParallelogram(
        rect: rect,
        skew: -verticalSkew,
        axis: Axis.vertical,
        paint:
            Paint()
              ..color = Colors.blueGrey
              ..style = PaintingStyle.fill
              ..strokeWidth = 1.0,
      );
      xOffset += barWidth + spacing;
    }
  }

  void drawCube({
    required Rect rect,
    required Paint paint,
    required Canvas canvas,
    double horizontalSkew = 10.0,
    double verticalSkew = 10.0,
  }) {}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

extension DrawShapes on Canvas {
  void drawParallelogram({
    required Rect rect,
    double skew = 10.0,
    Axis axis = Axis.horizontal,
    required Paint paint,
  }) {
    late Path path;
    if (axis == Axis.horizontal) {
      path =
          Path()
            ..moveTo(rect.left, rect.top)
            ..lineTo(rect.right, rect.top)
            ..lineTo(rect.right - skew, rect.bottom)
            ..lineTo(rect.left - skew, rect.bottom)
            ..lineTo(rect.left, rect.top);
    } else {
      path =
          Path()
            ..moveTo(rect.left, rect.top)
            ..lineTo(rect.right, rect.top - skew)
            ..lineTo(rect.right, rect.bottom - skew)
            ..lineTo(rect.left, rect.bottom)
            ..lineTo(rect.left, rect.top);
    }
    drawPath(path, paint);
  }
}
