import 'package:flutter/material.dart';
import '../models/competitor.dart';
import '../models/attempt.dart';
import '../models/competition.dart';
import 'results_screen.dart';

class AttemptsScreen extends StatefulWidget {
  const AttemptsScreen({super.key});

  @override
  State<AttemptsScreen> createState() => _AttemptsScreenState();
}

class _AttemptsScreenState extends State<AttemptsScreen> {
  late Competition competition;
  late Competitor currentUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final name = args['name'];
    final competitorsRaw = args['competitors'] as List<Map<String, dynamic>>;

    final competitors = competitorsRaw.map((c) {
      return Competitor(name: c['name'], bodyWeight: c['weight']);
    }).toList();

    competition = Competition(name: name, competitors: competitors);
    currentUser = competitors.first;
  }

  Future<void> _addAttempt(Competitor c, String liftType) async {
    final controller = TextEditingController();
    bool isValid = true;

    await showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: Text('Agregar intento (${_getLiftLabel(liftType)}) - ${c.name}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(labelText: 'Peso en kg'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  CheckboxListTile(
                    title: const Text('Intento válido'),
                    value: isValid,
                    onChanged: (value) {
                      setModalState(() {
                        isValid = value ?? true;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    final weight = double.tryParse(controller.text);
                    if (weight != null && weight > 0) {
                      setState(() {
                        c.attempts.add(
                          Attempt(
                            liftType: liftType,
                            weight: weight,
                            isValid: isValid,
                          ),
                        );
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final myPosition = competition.getPosition(currentUser);
    final weightToWin = competition.weightToWin(currentUser);

    return Scaffold(
      appBar: AppBar(title: Text(competition.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Tu posición actual: $myPositionº',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          if (weightToWin != null)
            Text(
              'Necesitas levantar ${weightToWin.toStringAsFixed(1)} kg más para ganar',
              style: const TextStyle(fontSize: 16, color: Colors.red),
            )
          else
            const Text(
              '¡Vas ganando!',
              style: TextStyle(fontSize: 16, color: Colors.green),
            ),
          const SizedBox(height: 20),

...competition.competitors.map((c) {
  return Card(
    key: ValueKey(c.name), // 👈 Esto es CLAVE
    child: ExpansionTile(
      title: Text('${c.name} (${c.bodyWeight} kg) - Total: ${c.total.toStringAsFixed(1)}'),
      children: [
        for (var lift in ['squat', 'bench', 'deadlift'])
          ListTile(
            title: Text('${_getLiftLabel(lift)}: ${_getBest(c, lift)} kg'),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                await _addAttempt(c, lift);
                setState(() {});
              },
            ),
          ),
      ],
    ),
  );
}).toList(),

          const SizedBox(height: 30),
          ElevatedButton.icon(
            icon: const Icon(Icons.leaderboard),
            label: const Text('Ver resultados finales'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ResultsScreen(
                    competition: competition,
                    user: currentUser,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _getLiftLabel(String lift) {
    switch (lift) {
      case 'squat':
        return 'Sentadilla';
      case 'bench':
        return 'Press de banca';
      case 'deadlift':
        return 'Peso muerto';
      default:
        return lift;
    }
  }

  double _getBest(Competitor c, String liftType) {
    final valid = c.attempts
        .where((a) => a.liftType == liftType && a.isValid)
        .map((e) => e.weight)
        .toList();
    if (valid.isEmpty) return 0;
    return valid.reduce((a, b) => a > b ? a : b);
  }
}
