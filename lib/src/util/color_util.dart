import 'dart:ui';

extension ColorUtil on Color {
  Color withOpacity(double opacity) => withOpacity(opacity);

  Color blend(Color other, [double t = 0.5]) =>
      Color.lerp(this, other, t) ?? other;
}
