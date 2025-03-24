import 'package:flutter/material.dart';
import '../models/competitor.dart';
import '../models/attempt.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final competitor = Competitor(name: 'Arlintong', bodyWeight: 65.4);

  void _addAttempt() {
    setState(() {
      competitor.attempts.add(Attempt(
        liftType: 'squat',
        weight: 195,
        isValid: true,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TEST')),
      body: Column(
        children: [
          Text('Sentadilla: ${competitor.squatBest} kg'),
          ElevatedButton(
            onPressed: _addAttempt,
            child: const Text('Agregar intento'),
          ),
        ],
      ),
    );
  }
}
