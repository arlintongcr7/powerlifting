import 'package:flutter/material.dart';
import '../models/competition.dart';
import '../models/competitor.dart';
import '../services/storage_service.dart';

class ResultsScreen extends StatelessWidget {
  final Competition competition;
  final Competitor user;

  const ResultsScreen({
    super.key,
    required this.competition,
    required this.user,
  });

  void _saveCompetition(BuildContext context) async {
    final data = {
      'name': competition.name,
      'date': DateTime.now().toIso8601String(),
      'results': competition.getSortedCompetitors().map((c) => {
        'name': c.name,
        'bodyWeight': c.bodyWeight,
        'total': c.total,
        'position': competition.getPosition(c),
      }).toList()
    };

    await StorageService.saveCompetition(data);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Competencia guardada en historial')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sorted = competition.getSortedCompetitors();

    return Scaffold(
      appBar: AppBar(title: const Text('Resultados Finales')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Competencia: ${competition.name}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: sorted.length,
                itemBuilder: (_, i) {
                  final c = sorted[i];
                  return ListTile(
                    leading: Text('${i + 1}º'),
                    title: Text(c.name),
                    subtitle: Text(
                      'Peso corporal: ${c.bodyWeight} kg\nTotal: ${c.total.toStringAsFixed(1)} kg',
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => _saveCompetition(context),
              child: const Text('Guardar competencia'),
            ),
          ],
        ),
      ),
    );
  }
}
