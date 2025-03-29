import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pseudo_3d_chart/src/util/color_util.dart';

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
  final double spacing;
  final double horizontalSkew;
  final double verticalSkew;

  const ChartWidget({
    super.key,
    required this.items,
    this.maxValue,
    this.spacing = 8.0,
    this.horizontalSkew = 8.0,
    this.verticalSkew = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final maxValueCalculated =
        maxValue ?? items.fold<double>(0.0, (sum, item) => sum + item.value);
    return CustomPaint(
      painter: ChartPainter(
        items: items,
        totalValue: maxValueCalculated,
        spacing: spacing,
        horizontalSkew: horizontalSkew,
        verticalSkew: verticalSkew,
      ),
    );
  }
}

class ChartPainter extends CustomPainter {
  final List<ChartItem> items;
  final double? totalValue;
  final double spacing;
  final double horizontalSkew;
  final double verticalSkew;

  ChartPainter({
    required this.items,
    required this.totalValue,
    required this.spacing,
    required this.horizontalSkew,
    required this.verticalSkew,
  });

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

    final rects = getRects(
      items,
      spacing,
      horizontalSkew,
      verticalSkew,
      total,
      availableWidth,
      maxHeight,
    );

    // Calculate positions for all bars first
    final positions = <double>[];
    var currentOffset = spacing + horizontalSkew;
    for (var i = 0; i < items.length; i++) {
      positions.add(currentOffset);
      final barWidth = (items[i].value / total) * availableWidth;
      currentOffset += barWidth + spacing;
    }

    // Process items in reverse order to draw right-most cubes first
    for (var i = items.length - 1; i >= 0; i--) {
      final item = items[i];

      // Calculate width based on value
      final barWidth = (item.value / total) * availableWidth;

      // Draw the bar
      final rect = Rect.fromLTWH(
        positions[i],
        verticalSkew,
        barWidth,
        maxHeight,
      );

      drawCube(
        rect: rect,
        color: item.color,
        canvas: canvas,
        horizontalSkew: horizontalSkew,
        verticalSkew: verticalSkew,
      );
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
    // Base paints
    final fillPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final strokePaint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

    // Define all faces of the cuboid

    // Front face
    final frontRect = rect;

    // Top face
    final topRect = Rect.fromLTWH(
      rect.left - horizontalSkew,
      rect.top - verticalSkew,
      rect.width,
      verticalSkew,
    );

    // Left face
    final leftRect = Rect.fromLTWH(
      rect.left - horizontalSkew,
      rect.top - verticalSkew,
      horizontalSkew,
      rect.height,
    );

    // First draw back wireframe edges
    final backPath = Path();

    // Top-right edge
    backPath.moveTo(rect.right, rect.top);
    backPath.lineTo(rect.right - horizontalSkew, rect.top - verticalSkew);

    // Back-right edge
    backPath.moveTo(rect.right - horizontalSkew, rect.top - verticalSkew);
    backPath.lineTo(rect.right - horizontalSkew, rect.bottom - verticalSkew);

    // Bottom-right edge
    backPath.moveTo(rect.right, rect.bottom);
    backPath.lineTo(rect.right - horizontalSkew, rect.bottom - verticalSkew);

    canvas.drawPath(backPath, strokePaint);

    // Draw background faces (parallelograms first)

    // 1. Draw left face filled
    canvas.drawParallelogram(
      rect: leftRect,
      skew: -verticalSkew,
      axis: Axis.vertical,
      paint: fillPaint..color = color.blend(Color(0xFF000000), 0.5),
    );

    // 2. Draw left face outline
    canvas.drawParallelogram(
      rect: leftRect,
      skew: -verticalSkew,
      axis: Axis.vertical,
      paint: strokePaint,
    );

    // 3. Draw top face filled
    canvas.drawParallelogram(
      rect: topRect,
      skew: -horizontalSkew,
      axis: Axis.horizontal,
      paint: fillPaint..color = color.blend(Color(0xFF000000), 0.3),
    );

    // 4. Draw top face outline
    canvas.drawParallelogram(
      rect: topRect,
      skew: -horizontalSkew,
      axis: Axis.horizontal,
      paint: strokePaint,
    );

    // Draw foreground face last

    // 5. Draw front face filled
    canvas.drawRect(frontRect, fillPaint..color = color);

    // 6. Draw front face outline
    canvas.drawRect(frontRect, strokePaint);
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
