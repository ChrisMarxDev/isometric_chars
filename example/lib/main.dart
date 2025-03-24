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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: 500,
        height: 64,
        child: ChartWidget(
          maxValue: 100,
          items: [
            ChartItem(identifier: 'A Test Value', color: Colors.red, value: 10),
            ChartItem(
              identifier: 'B Test Value',
              color: Colors.blue,
              value: 20,
            ),
            ChartItem(
              identifier: 'C Test Value',
              color: Colors.green,
              value: 30,
            ),
          ],
        ),
      ),
    );
  }
}
