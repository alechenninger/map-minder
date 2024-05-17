import 'package:map_minder/evolution_score.dart';

abstract class EvolutionRater {
  Future<EvolutionScore> score(Concept concept);
}

class Concept {
  final String name;

  Concept(this.name);

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) {
    if (other is Concept) {
      return name == other.name;
    }
    return false;
  }

  @override
  int get hashCode => name.hashCode;
}
