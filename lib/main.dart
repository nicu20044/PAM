import 'package:flutter/material.dart';

void main() {
  runApp(const FuelCalculatorApp());
}

class FuelCalculatorApp extends StatelessWidget {
  const FuelCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator Consum Combustibil',
      home: const FuelCalculatorScreen(),
    );
  }
}

class FuelCalculatorScreen extends StatefulWidget {
  const FuelCalculatorScreen({super.key});

  @override
  State<FuelCalculatorScreen> createState() =>
      _FuelCalculatorScreenState();
}

class _FuelCalculatorScreenState
    extends State<FuelCalculatorScreen> {
  final TextEditingController distanceController =
  TextEditingController();
  final TextEditingController fuelController =
  TextEditingController();

  String result = '';

  void calculateConsumption() {
    double? distance =
    double.tryParse(distanceController.text);
    double? fuel =
    double.tryParse(fuelController.text);

    if (distance == null ||
        fuel == null ||
        distance <= 0 ||
        fuel < 0) {
      setState(() {
        result = 'Introduceți valori valide!';
      });
      return;
    }

    double consumption = (fuel / distance) * 100;

    setState(() {
      result =
      'Consum mediu: ${consumption.toStringAsFixed(2)} L/100 km';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator Consum'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: distanceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Distanța parcursă (km)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: fuelController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Combustibil consumat (L)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculateConsumption,
              child: const Text('Calculează'),
            ),
            const SizedBox(height: 20),
            Text(
              result,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}