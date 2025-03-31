import 'package:flutter/material.dart';
import 'package:isometric_charts/isometric_charts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Isometric Charts',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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

class ExampleData {
  final String name;
  final double value;
  final Color color;

  ExampleData({required this.name, required this.value, required this.color});

  ExampleData copyWith({double? value, Color? color}) {
    return ExampleData(
      name: name,
      value: value ?? this.value,
      color: color ?? this.color,
    );
  }
}

enum TimePeriod {
  lastWeek,
  thisWeek,
  forecasted;

  String get label {
    switch (this) {
      case TimePeriod.thisWeek:
        return 'This Week';
      case TimePeriod.lastWeek:
        return 'Last Week';
      case TimePeriod.forecasted:
        return 'Forecasted';
    }
  }
}

final Map<TimePeriod, List<ExampleData>> timePeriodData = {
  TimePeriod.thisWeek: [
    ExampleData(
      name: 'Agriculture',
      value: 100,
      color: const Color(0xFF4CAF50), // Green
    ),
    ExampleData(
      name: 'Industry',
      value: 300,
      color: const Color(0xFF2196F3), // Blue
    ),
    ExampleData(
      name: 'Services',
      value: 200,
      color: const Color(0xFFFFC107), // Amber
    ),
  ],
  TimePeriod.lastWeek: [
    ExampleData(name: 'Agriculture', value: 60, color: const Color(0xFF4CAF50)),
    ExampleData(name: 'Industry', value: 220, color: const Color(0xFF2196F3)),
    ExampleData(name: 'Services', value: 150, color: const Color(0xFFFFC107)),
  ],
  TimePeriod.forecasted: [
    ExampleData(
      name: 'Agriculture',
      value: 140,
      color: const Color(0xFF4CAF50),
    ),
    ExampleData(name: 'Industry', value: 380, color: const Color(0xFF2196F3)),
    ExampleData(name: 'Services', value: 250, color: const Color(0xFFFFC107)),
  ],
};

final Map<TimePeriod, Map<String, List<ExampleData>>> detailedData = {
  TimePeriod.thisWeek: {
    'Agriculture': [
      ExampleData(name: 'Corn', value: 100, color: const Color(0xFF81C784)),
      ExampleData(name: 'Wheat', value: 300, color: const Color(0xFF66BB6A)),
      ExampleData(name: 'Soybeans', value: 200, color: const Color(0xFF4CAF50)),
      ExampleData(name: 'Potatoes', value: 400, color: const Color(0xFF388E3C)),
      ExampleData(name: 'Tomatoes', value: 500, color: const Color(0xFF2E7D32)),
    ],
    'Industry': [
      ExampleData(name: 'Steel', value: 100, color: const Color(0xFF64B5F6)),
      ExampleData(
        name: 'Automobiles',
        value: 300,
        color: const Color(0xFF42A5F5),
      ),
      ExampleData(
        name: 'Machinery',
        value: 200,
        color: const Color(0xFF2196F3),
      ),
      ExampleData(
        name: 'Electronics',
        value: 400,
        color: const Color(0xFF1E88E5),
      ),
    ],
    'Services': [
      ExampleData(
        name: 'Healthcare',
        value: 100,
        color: const Color(0xFFFFD54F),
      ),
      ExampleData(
        name: 'Education',
        value: 300,
        color: const Color(0xFFFFCA28),
      ),
      ExampleData(
        name: 'Financial',
        value: 200,
        color: const Color(0xFFFFC107),
      ),
      ExampleData(name: 'Retail', value: 400, color: const Color(0xFFFFB300)),
    ],
  },
  TimePeriod.lastWeek: {
    'Agriculture': [
      ExampleData(name: 'Corn', value: 80, color: const Color(0xFF81C784)),
      ExampleData(name: 'Wheat', value: 250, color: const Color(0xFF66BB6A)),
      ExampleData(name: 'Soybeans', value: 150, color: const Color(0xFF4CAF50)),
      ExampleData(name: 'Potatoes', value: 300, color: const Color(0xFF388E3C)),
      ExampleData(name: 'Tomatoes', value: 400, color: const Color(0xFF2E7D32)),
    ],
    'Industry': [
      ExampleData(name: 'Steel', value: 80, color: const Color(0xFF64B5F6)),
      ExampleData(
        name: 'Automobiles',
        value: 250,
        color: const Color(0xFF42A5F5),
      ),
      ExampleData(
        name: 'Machinery',
        value: 150,
        color: const Color(0xFF2196F3),
      ),
      ExampleData(
        name: 'Electronics',
        value: 300,
        color: const Color(0xFF1E88E5),
      ),
    ],
    'Services': [
      ExampleData(
        name: 'Healthcare',
        value: 80,
        color: const Color(0xFFFFD54F),
      ),
      ExampleData(
        name: 'Education',
        value: 250,
        color: const Color(0xFFFFCA28),
      ),
      ExampleData(
        name: 'Financial',
        value: 150,
        color: const Color(0xFFFFC107),
      ),
      ExampleData(name: 'Retail', value: 300, color: const Color(0xFFFFB300)),
    ],
  },
  TimePeriod.forecasted: {
    'Agriculture': [
      ExampleData(name: 'Corn', value: 120, color: const Color(0xFF81C784)),
      ExampleData(name: 'Wheat', value: 350, color: const Color(0xFF66BB6A)),
      ExampleData(name: 'Soybeans', value: 250, color: const Color(0xFF4CAF50)),
      ExampleData(name: 'Potatoes', value: 500, color: const Color(0xFF388E3C)),
      ExampleData(name: 'Tomatoes', value: 600, color: const Color(0xFF2E7D32)),
    ],
    'Industry': [
      ExampleData(name: 'Steel', value: 120, color: const Color(0xFF64B5F6)),
      ExampleData(
        name: 'Automobiles',
        value: 350,
        color: const Color(0xFF42A5F5),
      ),
      ExampleData(
        name: 'Machinery',
        value: 250,
        color: const Color(0xFF2196F3),
      ),
      ExampleData(
        name: 'Electronics',
        value: 500,
        color: const Color(0xFF1E88E5),
      ),
    ],
    'Services': [
      ExampleData(
        name: 'Healthcare',
        value: 120,
        color: const Color(0xFFFFD54F),
      ),
      ExampleData(
        name: 'Education',
        value: 350,
        color: const Color(0xFFFFCA28),
      ),
      ExampleData(
        name: 'Financial',
        value: 250,
        color: const Color(0xFFFFC107),
      ),
      ExampleData(name: 'Retail', value: 500, color: const Color(0xFFFFB300)),
    ],
  },
};

class _MyHomePageState extends State<MyHomePage> {
  double spacing = 4;
  double horizontalSkew = 16;
  double verticalSkew = 8;
  String? selectedItem;
  String? hoveredItem;
  List<ChartItem<String>> chartItems = [];
  TimePeriod selectedTimePeriod = TimePeriod.thisWeek;

  @override
  void initState() {
    super.initState();
    _updateChartItems();
  }

  void _updateChartItems() {
    chartItems =
        timePeriodData[selectedTimePeriod]!.map((data) {
          return ChartItem<String>(
            identifier: data.name,
            value: data.value,
            color: data.color,
          );
        }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pseudo 3D Chart Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: ExpansionTile(
                title: const Text(
                  'Chart Controls',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Time Period',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SegmentedButton<TimePeriod>(
                      segments:
                          TimePeriod.values.map((period) {
                            return ButtonSegment<TimePeriod>(
                              value: period,
                              label: Text(period.label),
                            );
                          }).toList(),
                      selected: {selectedTimePeriod},
                      onSelectionChanged: (Set<TimePeriod> newSelection) {
                        setState(() {
                          selectedTimePeriod = newSelection.first;
                          _updateChartItems();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chart',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 64,
                      width: double.infinity,
                      child: IsometricChartWidget<String>(
                        items: chartItems,
                        maxValue: 800,
                        spacing: spacing,
                        horizontalSkew: horizontalSkew,
                        verticalSkew: verticalSkew,
                        onHover: (item) {
                          setState(() {
                            // Reset all items to their original colors first
                            for (var i = 0; i < chartItems.length; i++) {
                              chartItems[i] = ChartItem<String>(
                                identifier: chartItems[i].identifier,
                                value: chartItems[i].value,
                                color:
                                    timePeriodData[selectedTimePeriod]![i]
                                        .color,
                              );
                            }

                            // If hovering over an item, highlight it by blending with white
                            if (item != null) {
                              final index = chartItems.indexWhere(
                                (i) => i.identifier == item.identifier,
                              );
                              if (index != -1) {
                                final originalColor =
                                    timePeriodData[selectedTimePeriod]![index]
                                        .color;
                                chartItems[index] = ChartItem<String>(
                                  identifier: item.identifier,
                                  value: item.value,
                                  color: originalColor.blend(Colors.white, 0.3),
                                );
                              }
                            }
                            hoveredItem = item?.identifier;
                          });
                        },
                        onTap: (item) {
                          setState(() {
                            selectedItem = item.identifier;
                          });
                        },
                      ),
                    ),
                    ...[const SizedBox(height: 8), Text(hoveredItem ?? ' ')],
                  ],
                ),
              ),
            ),
            ...[
              const SizedBox(height: 24),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  final offset = animation.drive(
                    Tween<Offset>(
                      begin: const Offset(-0.25, 0.0),
                      end: Offset.zero,
                    ),
                  );
                  return ColoredBox(
                    color:
                        animation.isAnimating
                            ? Theme.of(context).colorScheme.surface
                            : Colors.transparent,
                    child: FadeTransition(
                      opacity: animation,
                      child: SlideTransition(position: offset, child: child),
                    ),
                  );
                },
                child:
                    selectedItem == null
                        ? const SizedBox.shrink()
                        : Card(
                          key: Key(selectedItem!),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Details for $selectedItem',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        setState(() {
                                          selectedItem = null;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  height: 64,
                                  width: double.infinity,

                                  child: IsometricChartWidget<String>(
                                    borderColor: Colors.redAccent,
                                    borderWidth: 1,
                                    items:
                                        detailedData[selectedTimePeriod]![selectedItem!]!
                                            .map((data) {
                                              return ChartItem<String>(
                                                identifier: data.name,
                                                value: data.value,
                                                color: data.color,
                                              );
                                            })
                                            .toList(),
                                    spacing: spacing,
                                    horizontalSkew: horizontalSkew,
                                    verticalSkew: verticalSkew,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

extension ColorUtil on Color {
  Color withOpacity(double opacity) => withOpacity(opacity);

  Color blend(Color other, [double t = 0.5]) =>
      Color.lerp(this, other, t) ?? other;
}
