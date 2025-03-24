import 'competitor.dart';

class Competition {
  final String name;
  List<Competitor> competitors;

  Competition({
    required this.name,
    this.competitors = const [],
  });

  List<Competitor> getSortedCompetitors() {
    final sorted = [...competitors];
    sorted.sort((a, b) {
      if (a.total == b.total) {
        return a.bodyWeight.compareTo(b.bodyWeight);
      }
      return b.total.compareTo(a.total);
    });
    return sorted;
  }

  int getPosition(Competitor c) {
    final sorted = getSortedCompetitors();
    return sorted.indexOf(c) + 1;
  }

  double? weightToWin(Competitor you) {
    final sorted = getSortedCompetitors();
    final youIndex = sorted.indexOf(you);
    if (youIndex == 0) return null; // ya vas ganando

    final nextAbove = sorted[youIndex - 1];
    final difference = nextAbove.total - you.total;

    // Si tienen el mismo total, el más ligero gana
    if (difference == 0 && nextAbove.bodyWeight < you.bodyWeight) {
      return 0.1; // cualquier mejora mínima sirve
    }

    return difference <= 0 ? null : difference + 0.1;
  }
}
