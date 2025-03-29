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
    final maxValueCalculated =
        maxValue ?? items.fold<double>(0.0, (sum, item) => sum + item.value);
    return Container(
      color: Colors.red.withOpacity(0.1),
      child: CustomPaint(
        painter: ChartPainter(items: items, totalValue: maxValueCalculated),
      ),
    );
  }
}

class ChartPainter extends CustomPainter {
  final List<ChartItem> items;
  final double? totalValue;
  static const double spacing = 2.0;

  ChartPainter({required this.items, required this.totalValue});

  final horizontalSkew = 50.0;
  final verticalSkew = 20.0;

  @override
  void paint(Canvas canvas, Size size) {
    final twoDSize = Size(
      size.width - horizontalSkew,
      size.height - verticalSkew,
    );

    final total =
        totalValue ?? items.fold<double>(0.0, (sum, item) => sum + item.value);
    final maxHeight = twoDSize.height;
    final availableWidth = twoDSize.width - (items.length + 1) * spacing;

    var xOffset = spacing + horizontalSkew;

    final rects = getRects(
      items,
      spacing,
      horizontalSkew,
      verticalSkew,
      total,
      availableWidth,
      maxHeight,
    );
    for (var i = 0; i < items.length; i++) {
      final item = items[i];

      // Calculate width based on value
      final barWidth = (item.value / total) * availableWidth;

      // Draw the bar
      final rect = Rect.fromLTWH(xOffset, verticalSkew, barWidth, maxHeight);

      // Fill the bar
      // canvas.drawRect(
      //   rect,
      //   Paint()
      //     ..color = item.color
      //     ..style = PaintingStyle.fill,
      // );

      // // Draw black border
      // canvas.drawRect(
      //   rect,
      //   Paint()
      //     ..color = Colors.black
      //     ..style = PaintingStyle.stroke
      //     ..strokeWidth = 1.0,
      // );

      drawCube(
        rect: rect,
        color: item.color,
        canvas: canvas,
        horizontalSkew: horizontalSkew,
        verticalSkew: verticalSkew,
      );
      // xOffset += barWidth + spacing + horizontalSkew;
      xOffset += barWidth + spacing;
    }
  }

  Iterable<Rect> getRects(
    List<ChartItem> items,
    double spacing,
    double horizontalSkew,
    double verticalSkew,
    double total,
    double availableWidth,
    double maxHeight,
  ) {
    final result = <Rect>[];

    var xOffset = spacing + horizontalSkew;
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final barWidth = (item.value / total) * availableWidth;
      final rect = Rect.fromLTWH(xOffset, verticalSkew, barWidth, maxHeight);
      result.add(rect);
      xOffset += barWidth + spacing;
    }
    return result;
  }

  void drawCube({
    required Rect rect,
    required Color color,
    required Canvas canvas,
    double horizontalSkew = 20.0,
    double verticalSkew = 10.0,
  }) {
    // Draw front face (rectangle)
    final basePaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final borderPaint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

    canvas.drawRect(rect, basePaint);

    final topRect = Rect.fromLTWH(
      rect.left - horizontalSkew,
      rect.top - verticalSkew,
      rect.width,
      verticalSkew,
    );

    // Draw left side (parallelogram)
    canvas.drawParallelogram(
      rect: topRect,
      skew: -horizontalSkew,
      axis: Axis.horizontal,
      paint: basePaint..color = color.withOpacity(0.85),
    );

    final leftRect = Rect.fromLTWH(
      rect.left - horizontalSkew,
      rect.top - verticalSkew,
      horizontalSkew,
      rect.height,
    );

    canvas.drawParallelogram(
      rect: leftRect,
      skew: -verticalSkew,
      axis: Axis.vertical,
      paint: basePaint..color = color.withOpacity(0.85),
    );
  }

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
