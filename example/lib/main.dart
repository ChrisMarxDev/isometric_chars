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
    ChartItem(identifier: 'A Test Value', color: Colors.red, value: 10),
    ChartItem(identifier: 'B Test Value', color: Colors.blue, value: 20),
    ChartItem(identifier: 'C Test Value', color: Colors.green, value: 30),
  ];

  final items2 = [
    ChartItem(identifier: 'A Test Value', color: Colors.red, value: 10),
    ChartItem(identifier: 'B Test Value', color: Colors.blue, value: 20),
    ChartItem(identifier: 'C Test Value', color: Colors.green, value: 30),
    ChartItem(identifier: 'D Test Value', color: Colors.yellow, value: 40),
    ChartItem(identifier: 'E Test Value', color: Colors.orange, value: 50),
    ChartItem(identifier: 'F Test Value', color: Colors.purple, value: 60),
    ChartItem(identifier: 'G Test Value', color: Colors.pink, value: 70),
    ChartItem(identifier: 'H Test Value', color: Colors.brown, value: 80),
    ChartItem(identifier: 'I Test Value', color: Colors.grey, value: 90),
    ChartItem(identifier: 'J Test Value', color: Colors.teal, value: 100),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            SizedBox(
              height: 64,
              child: ChartWidget(maxValue: 100, items: items),
            ),

            SizedBox(height: 128, child: ChartWidget(items: items2)),
          ],
        ),
      ),
    );
  }
}
