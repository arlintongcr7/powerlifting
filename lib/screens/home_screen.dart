import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Powerlifting Tracker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bienvenido a tu control de competencias',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/new_competition');
              },
              child: const Text('Nueva competencia'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Aquí luego llamamos al historial
                Navigator.pushNamed(context, '/history');
              },
              child: const Text('Ver historial'),
            ),
          ],
        ),
      ),
    );
  }
}
