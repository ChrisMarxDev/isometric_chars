import 'dart:math';

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
  List<ChartItem> items = [
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

  List<ChartItem> items2 = [
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

  void randomizeChartItemValues() {
    final random = Random();

    setState(() {
      // First, randomly remove some items (but always keep at least 1)
      if (items.length > 1 && random.nextBool()) {
        final indexToRemove = random.nextInt(items.length);
        items.removeAt(indexToRemove);
      }

      // Randomize values of existing items
      final newItems =
          items.map((item) {
            return item.copyWith(value: random.nextInt(100).toDouble());
          }).toList();

      // Randomly add a new item (up to 5 total)
      if (items.length < 5 && random.nextBool()) {
        final letters = ['A', 'B', 'C', 'D', 'E'];
        final availableLetters =
            letters
                .where(
                  (letter) =>
                      !items.any(
                        (item) =>
                            (item.identifier as String).startsWith(letter),
                      ),
                )
                .toList();

        if (availableLetters.isNotEmpty) {
          final letter =
              availableLetters[random.nextInt(availableLetters.length)];
          final colors = [
            const Color(0xFFFF6B6B), // Coral Red
            const Color(0xFF4ECDC4), // Turquoise
            const Color(0xFFFFD166), // Yellow
            const Color(0xFF06D6A0), // Mint Green
            const Color(0xFF3A86FF), // Blue
          ];

          newItems.add(
            ChartItem(
              identifier: '$letter Test Value',
              color: colors[random.nextInt(colors.length)],
              value: random.nextInt(100).toDouble(),
            ),
          );
        }
      }

      items = newItems;
    });

    setState(() {
      // Same logic for items2
      // First, randomly remove some items (but always keep at least 3)
      if (items2.length > 3 && random.nextBool()) {
        final indexToRemove = random.nextInt(items2.length);
        items2.removeAt(indexToRemove);
      }

      // Randomize values of existing items
      final newItems2 =
          items2.map((item) {
            return item.copyWith(value: random.nextInt(100).toDouble());
          }).toList();

      // Randomly add a new item (up to 10 total)
      if (items2.length < 10 && random.nextBool()) {
        final letters = [
          'A',
          'B',
          'C',
          'D',
          'E',
          'F',
          'G',
          'H',
          'I',
          'J',
          'K',
          'L',
        ];
        final availableLetters =
            letters
                .where(
                  (letter) =>
                      !items2.any(
                        (item) =>
                            (item.identifier as String).startsWith(letter),
                      ),
                )
                .toList();

        if (availableLetters.isNotEmpty) {
          final letter =
              availableLetters[random.nextInt(availableLetters.length)];
          final colors = [
            const Color(0xFFFF6B6B), // Coral Red
            const Color(0xFFFF8E53), // Orange
            const Color(0xFFFFD166), // Yellow
            const Color(0xFF06D6A0), // Mint Green
            const Color(0xFF4ECDC4), // Turquoise
            const Color(0xFF1A535C), // Dark Teal
            const Color(0xFF3A86FF), // Blue
            const Color(0xFF7209B7), // Purple
            const Color(0xFFF72585), // Pink
            const Color(0xFFB5179E), // Magenta
          ];

          newItems2.add(
            ChartItem(
              identifier: '$letter Test Value',
              color: colors[random.nextInt(colors.length)],
              value: random.nextInt(100).toDouble(),
            ),
          );
        }
      }

      items2 = newItems2;
    });
  }

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
            ElevatedButton(
              onPressed: randomizeChartItemValues,
              child: const Text('Randomize, Add & Remove Items'),
            ),

            SizedBox(
              height: 64,
              child: AnimatedChartWidget(
                maxValue: 1000,

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
              child: AnimatedChartWidget(
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
