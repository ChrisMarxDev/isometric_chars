import 'package:flutter/material.dart';
import 'package:pseudo_3d_chart/pseudo_3d_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final items = [
    ChartItem(
      identifier: 'A Test Value',
      color: const Color(0xFFFF6B6B),
      value: 10,
    ),
    ChartItem(
      identifier: 'B Test Value',
      color: const Color(0xFF4ECDC4),
      value: 20,
    ),
    ChartItem(
      identifier: 'C Test Value',
      color: const Color(0xFFFFD166),
      value: 30,
    ),
  ];

  final items2 = [
    ChartItem(
      identifier: 'A Test Value',
      color: const Color(0xFFFF6B6B),
      value: 10,
    ), // Coral Red
    ChartItem(
      identifier: 'B Test Value',
      color: const Color(0xFFFF8E53),
      value: 20,
    ), // Orange
    ChartItem(
      identifier: 'C Test Value',
      color: const Color(0xFFFFD166),
      value: 30,
    ), // Yellow
    ChartItem(
      identifier: 'D Test Value',
      color: const Color(0xFF06D6A0),
      value: 40,
    ), // Mint Green
    ChartItem(
      identifier: 'E Test Value',
      color: const Color(0xFF4ECDC4),
      value: 50,
    ), // Turquoise
    ChartItem(
      identifier: 'F Test Value',
      color: const Color(0xFF1A535C),
      value: 60,
    ), // Dark Teal
    ChartItem(
      identifier: 'G Test Value',
      color: const Color(0xFF3A86FF),
      value: 70,
    ), // Blue
    ChartItem(
      identifier: 'H Test Value',
      color: const Color(0xFF7209B7),
      value: 80,
    ), // Purple
    ChartItem(
      identifier: 'I Test Value',
      color: const Color(0xFFF72585),
      value: 90,
    ), // Pink
    ChartItem(
      identifier: 'J Test Value',
      color: const Color(0xFFB5179E),
      value: 100,
    ), // Magenta
  ];

  double spacing = 16;
  double horizontalSkew = 16;
  double verticalSkew = 16;
  double chartHeight = 150;

  String selectedItem = '';
  String hoveredItem = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pseudo 3D Chart Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Spacing:'),
            Slider(
              value: spacing,
              min: 0,
              max: 50,
              onChanged: (value) {
                setState(() {
                  spacing = value;
                });
              },
            ),

            const Text('Horizontal Skew:'),
            Slider(
              value: horizontalSkew,
              min: 0,
              max: 50,
              onChanged: (value) {
                setState(() {
                  horizontalSkew = value;
                });
              },
            ),

            const Text('Vertical Skew:'),
            Slider(
              value: verticalSkew,
              min: 0,
              max: 50,
              onChanged: (value) {
                setState(() {
                  verticalSkew = value;
                });
              },
            ),

            // const Text('Chart Height:'),
            // Slider(
            //   value: chartHeight,
            //   min: 50,
            //   max: 300,
            //   onChanged: (value) {
            //     setState(() {
            //       chartHeight = value;
            //     });
            //   },
            // ),
            const SizedBox(height: 24),

            SizedBox(
              height: 64,
              child: ChartWidget(
                maxValue: 100,
                items: items,
                spacing: spacing,
                horizontalSkew: horizontalSkew,
                verticalSkew: verticalSkew,
              ),
            ),

            const SizedBox(height: 24),
            Text('Selected Item: $selectedItem'),
            Text('Hovered Item: $hoveredItem'),
            SizedBox(
              height: chartHeight,
              child: ChartWidget(
                items: items2,
                spacing: spacing,
                horizontalSkew: horizontalSkew,
                verticalSkew: verticalSkew,
                onHover: (p0) {
                  setState(() {
                    hoveredItem = p0.identifier;
                  });
                },
                onHoverExit: () {
                  setState(() {
                    hoveredItem = '';
                  });
                },
                onTap: (p0) {
                  setState(() {
                    selectedItem = p0.identifier;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
