import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:isometric_charts/src/util/color_util.dart';

class ChartItem<T> {
  final T identifier;
  final Color color;
  final double value;
  final String? semanticLabel;

  ChartItem({
    required this.identifier,
    required this.color,
    required this.value,
    this.semanticLabel,
  });

  ChartItem<T> lerp(ChartItem<T> other, double t) {
    return ChartItem<T>(
      identifier: identifier,
      color: Color.lerp(color, other.color, t) ?? other.color,
      value: lerpDouble(value, other.value, t) ?? other.value,
    );
  }

  ChartItem<T> copyWith({double? value}) {
    return ChartItem<T>(
      identifier: identifier,
      color: color,
      value: value ?? this.value,
    );
  }
}

final baseBorderPaint =
    Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

enum IsometricShapeSide { top, side, front }

class IsometricChartWidget<T> extends StatefulWidget {
  final List<ChartItem<T>> items;
  final double? maxValue;
  final double spacing;
  final double horizontalSkew;
  final double verticalSkew;
  final void Function(ChartItem<T>)? onTap;
  final void Function(ChartItem<T>?)? onHover;
  final Duration duration;
  final Curve curve;
  final bool animate;
  final Color borderColor;
  final double borderWidth;

  final Color Function(ChartItem<T> item, int index)? colorFunction;

  const IsometricChartWidget({
    super.key,
    required this.items,
    this.maxValue,
    this.spacing = 8.0,
    this.horizontalSkew = 8.0,
    this.verticalSkew = 8.0,
    this.onTap,
    this.onHover,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.colorFunction,
    this.borderColor = Colors.black,
    this.borderWidth = 1.0,
    this.animate = true,
  });

  @override
  State<IsometricChartWidget<T>> createState() =>
      _IsometricChartWidgetState<T>();
}

class _IsometricChartWidgetState<T> extends State<IsometricChartWidget<T>>
    with TickerProviderStateMixin {
  // Map to track individual item value animations
  final Map<T, AnimationController> _itemControllers = {};
  final Map<T, Animation<double>> _itemAnimations = {};
  final Map<T, double> _previousValues = {};

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  @override
  void didUpdateWidget(IsometricChartWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check for any changes in items
    final oldItemMap = {
      for (var item in oldWidget.items) item.identifier: item,
    };
    final newItemMap = {for (var item in widget.items) item.identifier: item};

    // Update or create animations for each item
    for (final item in widget.items) {
      final id = item.identifier;

      // If the item existed before and value changed
      if (oldItemMap.containsKey(id) && oldItemMap[id]!.value != item.value) {
        print(
          'Value changed for $id: ${oldItemMap[id]!.value} -> ${item.value}',
        );

        // Save previous value for animation
        _previousValues[id] = oldItemMap[id]!.value;

        // Create controller if needed
        if (!_itemControllers.containsKey(id)) {
          _setupAnimationForItem(id, item);
        } else {
          // Reset and start the animation for this item
          _itemControllers[id]!.duration = widget.duration;
          _itemAnimations[id] = Tween<double>(
            begin: _previousValues[id] ?? 0.0,
            end: item.value,
          ).animate(
            CurvedAnimation(parent: _itemControllers[id]!, curve: widget.curve),
          );
          _itemControllers[id]!.forward(from: 0.0);
        }
      }
      // New item
      else if (!oldItemMap.containsKey(id)) {
        print('New item: $id with value ${item.value}');
        _setupAnimationForItem(id, item, from: 0.0);
      }
    }

    // Handle removed items
    for (final id in oldItemMap.keys) {
      if (!newItemMap.containsKey(id)) {
        print('Item removed: $id');
        // Could animate removal if needed
        _itemControllers[id]?.dispose();
        _itemControllers.remove(id);
        _itemAnimations.remove(id);
        _previousValues.remove(id);
      }
    }
  }

  void _setupAnimations() {
    for (final item in widget.items) {
      _setupAnimationForItem(item.identifier, item);
    }
  }

  void _setupAnimationForItem(T id, ChartItem<T> item, {double? from}) {
    // Create a controller for this item
    final controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Setup the animation
    final animation = Tween<double>(
      begin: from ?? 0.0,
      end: item.value,
    ).animate(CurvedAnimation(parent: controller, curve: widget.curve));

    // Start the animation
    controller.forward();

    // Store the controller and animation
    _itemControllers[id] = controller;
    _itemAnimations[id] = animation;
    _previousValues[id] = from ?? 0.0;

    // Set up a listener to rebuild the widget
    animation.addListener(() {
      setState(() {
        // Just to trigger a rebuild
      });
    });
  }

  @override
  void dispose() {
    // Dispose all animation controllers
    for (final controller in _itemControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // Get the current animated value for an item
  double _getAnimatedValue(ChartItem<T> item) {
    final id = item.identifier;

    // If we have an animation for this item, use its current value
    if (_itemAnimations.containsKey(id) && _itemControllers[id]!.isAnimating) {
      return _itemAnimations[id]!.value;
    }

    // Otherwise use the actual value
    return item.value;
  }

  // Create animating chart items based on actual items but with animated values
  List<ChartItem<T>> _getAnimatedItems() {
    return widget.items.map((item) {
      return ChartItem<T>(
        identifier: item.identifier,
        color: item.color,
        value: _getAnimatedValue(item),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final animatedItems = _getAnimatedItems();

    return ChartWidget<T>(
      items: animatedItems,
      maxValue: widget.maxValue,
      spacing: widget.spacing,
      horizontalSkew: widget.horizontalSkew,
      verticalSkew: widget.verticalSkew,
      onTap: widget.onTap,
      onHover: widget.onHover,
      borderColor: widget.borderColor,
      borderWidth: widget.borderWidth,
    );
  }
}

class ChartWidget<T> extends StatefulWidget {
  final List<ChartItem<T>> items;
  final double? maxValue;
  final double spacing;
  final double horizontalSkew;
  final double verticalSkew;
  final void Function(ChartItem<T>)? onTap;
  final void Function(ChartItem<T>?)? onHover;
  final Color borderColor;
  final double borderWidth;

  const ChartWidget({
    super.key,
    required this.items,
    this.maxValue,
    this.spacing = 8.0,
    this.horizontalSkew = 8.0,
    this.verticalSkew = 8.0,
    this.onTap,
    this.onHover,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  State<ChartWidget<T>> createState() => _ChartWidgetState<T>();
}

class _ChartWidgetState<T> extends State<ChartWidget<T>> {
  final GlobalKey _canvasKey = GlobalKey();
  ChartItem<T>? _hoveredItem;

  @override
  Widget build(BuildContext context) {
    final maxValueCalculated =
        widget.maxValue ??
        widget.items.fold<double>(0.0, (sum, item) => sum + item.value);

    final chartPainter = ChartPainter<T>(
      items: widget.items,
      totalValue: maxValueCalculated,
      spacing: widget.spacing,
      horizontalSkew: widget.horizontalSkew,
      verticalSkew: widget.verticalSkew,
      borderColor: widget.borderColor,
      borderWidth: widget.borderWidth,
    );

    return GestureDetector(
      onTapUp: widget.onTap == null ? null : _handleTap,
      child: MouseRegion(
        onHover: widget.onHover == null ? null : _handleHover,
        child: CustomPaint(key: _canvasKey, painter: chartPainter),
      ),
    );
  }

  void _handleTap(TapUpDetails details) {
    final RenderBox renderBox =
        _canvasKey.currentContext!.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);

    final item = _getItemAtPosition(localPosition, renderBox.size);
    if (item != null && widget.onTap != null) {
      widget.onTap!(item);
    }
  }

  void _handleHover(PointerHoverEvent event) {
    final RenderBox renderBox =
        _canvasKey.currentContext!.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(event.position);

    final item = _getItemAtPosition(localPosition, renderBox.size);

    if (widget.onHover != null) {
      widget.onHover!(item);
    }
  }

  ChartItem<T>? _getItemAtPosition(Offset position, Size size) {
    final twoDSize = Size(
      size.width - widget.horizontalSkew,
      size.height - widget.verticalSkew,
    );

    final total =
        widget.maxValue ??
        widget.items.fold<double>(0.0, (sum, item) => sum + item.value);
    final availableWidth =
        twoDSize.width - (widget.items.length + 1) * widget.spacing;

    // Calculate all rects and check if point is inside
    var currentOffset = widget.spacing;
    for (var i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];
      final barWidth = (item.value / total) * availableWidth;

      // Create all faces of the cube to check for interaction
      final frontRect = Rect.fromLTWH(
        currentOffset + widget.horizontalSkew,
        widget.verticalSkew,
        barWidth,
        twoDSize.height,
      );

      final topRect = Rect.fromLTWH(
        currentOffset,
        0,
        barWidth,
        widget.verticalSkew,
      );

      final leftRect = Rect.fromLTWH(
        currentOffset,
        0,
        widget.horizontalSkew,
        twoDSize.height + widget.verticalSkew,
      );

      // Check if position is inside any of the faces
      if (frontRect.contains(position) ||
          _isInsideParallelogram(
            position,
            topRect,
            -widget.horizontalSkew,
            Axis.horizontal,
          ) ||
          _isInsideParallelogram(
            position,
            leftRect,
            -widget.verticalSkew,
            Axis.vertical,
          )) {
        return item;
      }

      currentOffset += barWidth + widget.spacing;
    }

    return null;
  }

  bool _isInsideParallelogram(Offset point, Rect rect, double skew, Axis axis) {
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

    return path.contains(point);
  }
}

class ChartPainter<T> extends CustomPainter {
  final List<ChartItem<T>> items;
  final double? totalValue;
  final double spacing;
  final double horizontalSkew;
  final double verticalSkew;
  final Color borderColor;
  final double borderWidth;

  ChartPainter({
    required this.items,
    required this.totalValue,
    required this.spacing,
    required this.horizontalSkew,
    required this.verticalSkew,
    required this.borderColor,
    required this.borderWidth,
  });

  Paint get _borderPaint =>
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth;

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

    // final rects = getRects(
    //   items,
    //   spacing,
    //   horizontalSkew,
    //   verticalSkew,
    //   total,
    //   availableWidth,
    //   maxHeight,
    // );

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
    List<ChartItem<T>> items,
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

    // Define all faces of the cuboid
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

    // Draw visible back edges first
    final backPath =
        Path()
          ..moveTo(rect.right, rect.top)
          ..lineTo(rect.right - horizontalSkew, rect.top - verticalSkew)
          ..moveTo(rect.right - horizontalSkew, rect.top - verticalSkew)
          ..lineTo(rect.right - horizontalSkew, rect.bottom - verticalSkew)
          ..moveTo(rect.right, rect.bottom)
          ..lineTo(rect.right - horizontalSkew, rect.bottom - verticalSkew);

    canvas.drawPath(backPath, _borderPaint);

    // Draw faces in correct order for proper occlusion

    // 1. Draw front face filled
    canvas.drawRect(frontRect, fillPaint..color = color);

    // 2. Draw left face filled
    canvas.drawParallelogram(
      rect: leftRect,
      skew: -verticalSkew,
      axis: Axis.vertical,
      paint: fillPaint..color = color.blend(Color(0xFF000000), 0.5),
    );

    // 3. Draw top face filled
    canvas.drawParallelogram(
      rect: topRect,
      skew: -horizontalSkew,
      axis: Axis.horizontal,
      paint: fillPaint..color = color.blend(Color(0xFF000000), 0.3),
    );

    // Draw all borders last to ensure clean edges

    // 4. Draw front face outline
    canvas.drawRect(frontRect, _borderPaint);

    // 5. Draw left face outline
    canvas.drawParallelogram(
      rect: leftRect,
      skew: -verticalSkew,
      axis: Axis.vertical,
      paint: _borderPaint,
    );

    // 6. Draw top face outline
    canvas.drawParallelogram(
      rect: topRect,
      skew: -horizontalSkew,
      axis: Axis.horizontal,
      paint: _borderPaint,
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
