import 'package:flutter/material.dart';

class NewCompetitionScreen extends StatefulWidget {
  const NewCompetitionScreen({super.key});

  @override
  State<NewCompetitionScreen> createState() => _NewCompetitionScreenState();
}

class _NewCompetitionScreenState extends State<NewCompetitionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _competitionNameController = TextEditingController();
  List<Map<String, dynamic>> competitors = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  void _addCompetitor() {
    if (_nameController.text.isNotEmpty && _weightController.text.isNotEmpty) {
      setState(() {
        competitors.add({
          'name': _nameController.text,
          'weight': double.tryParse(_weightController.text) ?? 0,
        });
        _nameController.clear();
        _weightController.clear();
      });
    }
  }

  void _continue() {
    if (_competitionNameController.text.isEmpty || competitors.isEmpty) return;

    Navigator.pushNamed(
      context,
      '/attempts',
      arguments: {
        'name': _competitionNameController.text,
        'competitors': competitors,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva competencia')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _competitionNameController,
              decoration: const InputDecoration(labelText: 'Nombre del evento'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nombre competidor'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    decoration: const InputDecoration(labelText: 'Peso corporal'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addCompetitor,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: competitors.length,
                itemBuilder: (_, index) {
                  final c = competitors[index];
                  return ListTile(
                    title: Text(c['name']),
                    subtitle: Text('Peso: ${c['weight']} kg'),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _continue,
              child: const Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}
