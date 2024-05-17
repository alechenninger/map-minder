class EvolutionScore {
  final CharacteristicScore ubiquity;
  final CharacteristicScore certainty;
  final CharacteristicScore publicationTypes;
  final CharacteristicScore market;
  final CharacteristicScore knowledgeManagement;
  final CharacteristicScore marketPerception;
  final CharacteristicScore userPerception;
  final CharacteristicScore perceptionInIndustry;
  final CharacteristicScore focusOfValue;
  final CharacteristicScore understanding;
  final CharacteristicScore comparison;
  final CharacteristicScore failure;
  final CharacteristicScore marketAction;
  final CharacteristicScore efficiency;
  final CharacteristicScore decisionDrivers;

  final CharacteristicScore averageScore;

  EvolutionScore({
    required this.ubiquity,
    required this.certainty,
    required this.publicationTypes,
    required this.market,
    required this.knowledgeManagement,
    required this.marketPerception,
    required this.userPerception,
    required this.perceptionInIndustry,
    required this.focusOfValue,
    required this.understanding,
    required this.comparison,
    required this.failure,
    required this.marketAction,
    required this.efficiency,
    required this.decisionDrivers,
  }) : averageScore = _calculateAverageScore([
          ubiquity,
          certainty,
          publicationTypes,
          market,
          knowledgeManagement,
          marketPerception,
          userPerception,
          perceptionInIndustry,
          focusOfValue,
          understanding,
          comparison,
          failure,
          marketAction,
          efficiency,
          decisionDrivers,
        ]);

  static CharacteristicScore _calculateAverageScore(
      List<CharacteristicScore> scores) {
    double sum = 0;
    for (var score in scores) {
      sum += score.value;
    }
    double average = sum / scores.length;
    return CharacteristicScore(average);
  }

  @override
  String toString() {
    return 'EvolutionScore{'
        'ubiquity: $ubiquity, '
        'certainty: $certainty, '
        'publicationTypes: $publicationTypes, '
        'market: $market, '
        'knowledgeManagement: $knowledgeManagement, '
        'marketPerception: $marketPerception, '
        'userPerception: $userPerception, '
        'perceptionInIndustry: $perceptionInIndustry, '
        'focusOfValue: $focusOfValue, '
        'understanding: $understanding, '
        'comparison: $comparison, '
        'failure: $failure, '
        'marketAction: $marketAction, '
        'efficiency: $efficiency, '
        'decisionDrivers: $decisionDrivers, '
        'averageScore: $averageScore}';
  }

  @override
  bool operator ==(Object other) {
    if (other is EvolutionScore) {
      return ubiquity == other.ubiquity &&
          certainty == other.certainty &&
          publicationTypes == other.publicationTypes &&
          market == other.market &&
          knowledgeManagement == other.knowledgeManagement &&
          marketPerception == other.marketPerception &&
          userPerception == other.userPerception &&
          perceptionInIndustry == other.perceptionInIndustry &&
          focusOfValue == other.focusOfValue &&
          understanding == other.understanding &&
          comparison == other.comparison &&
          failure == other.failure &&
          marketAction == other.marketAction &&
          efficiency == other.efficiency &&
          decisionDrivers == other.decisionDrivers;
    }
    return false;
  }

  @override
  int get hashCode {
    return ubiquity.hashCode ^
        certainty.hashCode ^
        publicationTypes.hashCode ^
        market.hashCode ^
        knowledgeManagement.hashCode ^
        marketPerception.hashCode ^
        userPerception.hashCode ^
        perceptionInIndustry.hashCode ^
        focusOfValue.hashCode ^
        understanding.hashCode ^
        comparison.hashCode ^
        failure.hashCode ^
        marketAction.hashCode ^
        efficiency.hashCode ^
        decisionDrivers.hashCode;
  }
}

enum Stage { one, two, three, four }

class CharacteristicScore {
  final double value;
  //Stage get stage =>

  /// [value] must be between 0 and 4.
  CharacteristicScore(this.value) {
    if (value < 1 || value > 5) {
      throw ArgumentError.value(value, 'value', 'must be between 1 and 5');
    }
  }

  @override
  String toString() => value.toString();

  @override
  bool operator ==(Object other) {
    if (other is CharacteristicScore) {
      return value == other.value;
    }
    return false;
  }

  @override
  int get hashCode => value.hashCode;
}

enum EvolutionaryCharacteristic {
  ubiquity('Ubiquity', [
    'Rare',
    'Slowly increasing consumption',
    'Rapidly increasing consumption',
    'Widespread and stabilising'
  ]),
  certainty('Certainty', [
    'Poorly understood',
    'Rapid increases in learning',
    'Rapid increases in use / fit for purpose',
    'Commonly understood (in terms of use)'
  ]),
  publicationTypes('Publication Types', [
    'Normally describe the wonder of the thing',
    'Build / construct / awareness and learning',
    'Maintenance / operations / installation / features',
    'Focused on use'
  ]),
  market('Market', [
    'Undefined market',
    'Forming market',
    'Growing market',
    'Mature market'
  ]),
  knowledgeManagement('Knowledge Management', [
    'Uncertain',
    'Learning on use',
    'Learning on operation',
    'Known / accepted'
  ]),
  marketPerception('Market Perception', [
    'Chaotic (non-linear)',
    'Domain of experts',
    'Increasing expectations of use',
    'Ordered (appearance of being linear) / trivial'
  ]),
  userPerception('User Perception', [
    'Different / confusing / exciting / surprising',
    'Leading edge / emerging',
    'Common / disappointed if not used or available',
    'Standard / expected'
  ]),
  perceptionInIndustry('Perception in Industry', [
    'Competitive advantage / unpredictable / unknown',
    'Competitive advantage / ROI / case examples',
    'Advantage through implementation / features',
    'Cost of doing business / accepted'
  ]),
  focusOfValue('Focus of Value', [
    'High future worth',
    'Seeking profit / ROI?',
    'High profitability',
    'High volume / reducing margin'
  ]),
  understanding('Understanding', [
    'Poorly understood / unpredictable',
    'Increasing understanding / development of measures',
    'Increasing education / constant refinement of needs / measures',
    'Believed to be well defined / stable / measurable'
  ]),
  comparison('Comparison', [
    'Constantly changing / a differential / unstable',
    'Learning from others / testing the water / some evidential support',
    'Feature difference',
    'Essential / operational advantage'
  ]),
  failure('Failure', [
    'High / tolerated / assumed',
    'Moderate / unsurprising but disappointed',
    'Not tolerated, focus on constant improvement',
    'Operational efficiency and surprised by failure'
  ]),
  marketAction('Market Action', [
    'Gambling / driven by gut',
    'Exploring a "found" value',
    'Market analysis / listening to customers',
    'Metric driven / build what is needed'
  ]),
  efficiency('Efficiency', [
    'Reducing the cost of change (experimentation)',
    'Reducing cost of waste (Learning)',
    'Reducing cost of waste (Learning)',
    'Reducing cost of deviation (Volume)'
  ]),
  decisionDrivers('Decision Drivers', [
    'Heritage / culture',
    'Analysis & synthesis',
    'Analysis & synthesis',
    'Previous experience'
  ]);

  final String name;
  final List<String> stages;

  const EvolutionaryCharacteristic(this.name, this.stages);
}
