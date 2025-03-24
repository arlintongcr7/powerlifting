import 'attempt.dart';

class Competitor {
  final String name;
  final double bodyWeight;
  List<Attempt> attempts = [];

  Competitor({
    required this.name,
    required this.bodyWeight,
  });

  double get squatBest => _getBestLift('squat');
  double get benchBest => _getBestLift('bench');
  double get deadliftBest => _getBestLift('deadlift');

  double get total => squatBest + benchBest + deadliftBest;

  double _getBestLift(String type) {
    final validAttempts = attempts
        .where((a) => a.liftType == type && a.isValid)
        .map((a) => a.weight)
        .toList();

    if (validAttempts.isEmpty) return 0;
    return validAttempts.reduce((a, b) => a > b ? a : b);
  }
}
