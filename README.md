# Pseudo 3D Chart

A Flutter package that provides beautiful pseudo-3D charts with an isometric perspective. This package allows you to create visually appealing data visualizations with a unique depth effect.

![Example Chart](/iso_chart.gif)

## Features

- 🎨 Pseudo-3D visualization with isometric perspective
- 🎯 Interactive features (hover and tap callbacks)
- 🎛️ Customizable chart styling:
  - Spacing between bars
  - Horizontal and vertical skew angles
  - Custom colors for each bar
  - Border color and width
- 📱 Responsive design that works across all Flutter platforms
- 🎯 Easy-to-use API

## Getting Started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  pseudo_3d_chart: ^1.0.0  # Use the latest version
```

## Usage

Here's a simple example of how to use the Pseudo 3D Chart:

```dart
import 'package:pseudo_3d_chart/pseudo_3d_chart.dart';

class ChartDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IsometricChartWidget<String>(
        items: [
          ChartItem<String>(
            identifier: 'Item 1',
            value: 100,
            color: Colors.blue,
          ),
          ChartItem<String>(
            identifier: 'Item 2',
            value: 200,
            color: Colors.green,
          ),
          // Add more items as needed
        ],
        spacing: 4, // Space between bars
        horizontalSkew: 16, // Horizontal perspective angle
        verticalSkew: 8, // Vertical perspective angle
        onHover: (item) {
          // Handle hover events
        },
        onTap: (item) {
          // Handle tap events
        },
      ),
    );
  }
}
```

## Customization

The chart can be customized with various options:

- `spacing`: Controls the space between bars
- `horizontalSkew`: Adjusts the horizontal perspective angle
- `verticalSkew`: Adjusts the vertical perspective angle
- `borderColor`: Customize the border color of the chart
- `borderWidth`: Set the width of the chart border
- Custom colors for each bar item
- Interactive callbacks for hover and tap events

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
