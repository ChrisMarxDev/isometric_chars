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
  static const double verticalSpacing = 0.0;
  static const double horizontalSpacing = 2.0;

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
    final maxHeight = twoDSize.height - 2 * verticalSpacing;
    final availableWidth =
        twoDSize.width - (items.length + 1) * horizontalSpacing;

    var xOffset = horizontalSpacing;

    // Draw bars from left to right
    for (var i = 0; i < items.length; i++) {
      final item = items[i];

      // Calculate width based on value
      final barWidth = (item.value / total) * availableWidth;

      // Draw the bar
      final rect = Rect.fromLTWH(
        xOffset + horizontalSkew,
        verticalSpacing + verticalSkew,
        barWidth,
        maxHeight - verticalSkew,
      );

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

      xOffset += barWidth + horizontalSpacing;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
