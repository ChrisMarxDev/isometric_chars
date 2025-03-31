# Pseudo 3D Chart

A Flutter package that provides beautiful pseudo-3D charts with an isometric perspective. This package allows you to create visually appealing data visualizations with a unique depth effect.

![Example Chart](assets/iso_chart.gif)

## Features

- 🎨 Pseudo-3D visualization with isometric perspective
- 📊 Support for different time periods (Last Week, This Week, Forecasted)
- 🎛️ Customizable chart controls
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
      body: Pseudo3DChart(
        data: [
          ChartData(
            label: 'Services',
            values: [100, 150, 200],
            color: Colors.blue,
          ),
          // Add more data points as needed
        ],
        timePeriod: TimePeriod.lastWeek,
        // Additional configuration options
      ),
    );
  }
}
```

## Customization

The chart can be customized with various options:

- Color schemes
- Time period selection
- Chart dimensions
- Animation duration
- View perspective

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
