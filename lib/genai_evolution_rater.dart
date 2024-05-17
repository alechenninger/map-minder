import 'package:langchain/langchain.dart';
import 'package:map_minder/evolution_rater.dart';
import 'package:map_minder/evolution_score.dart';
import 'package:map_minder/genai_prompts.dart';

import 'dart:convert';

class GenAiEvolutionRater extends EvolutionRater {
  final BaseChatModel _llm;
  final ScorePrompts _prompts;
  final PromptStrategy _promptStrategy;

  GenAiEvolutionRater(this._llm, this._prompts,
      {PromptStrategy? promptStrategy})
      : _promptStrategy = promptStrategy ?? ManyShotPromptStrategy();

  @override
  Future<EvolutionScore> score(Concept concept) async {
    return _promptStrategy.prompt(_llm, concept, _prompts);
  }
}

abstract class PromptStrategy {
  Future<EvolutionScore> prompt(
      BaseChatModel model, Concept concept, ScorePrompts prompts);
}

class OneShotPromptStrategy extends PromptStrategy {
  @override
  Future<EvolutionScore> prompt(
      BaseLanguageModel model, Concept concept, ScorePrompts prompts) async {
    var prompt = await prompts.toScore(
        EvolutionaryCharacteristic.values.toSet(), concept);
    print(prompt);
    var result = await model.invoke(prompt);
    print(result);
    var scoreResults = jsonDecode(result.outputAsString);

    return EvolutionScore(
      ubiquity:
          _parseScore(scoreResults, EvolutionaryCharacteristic.ubiquity.name),
      certainty:
          _parseScore(scoreResults, EvolutionaryCharacteristic.certainty.name),
      publicationTypes: _parseScore(
          scoreResults, EvolutionaryCharacteristic.publicationTypes.name),
      market: _parseScore(scoreResults, EvolutionaryCharacteristic.market.name),
      knowledgeManagement: _parseScore(
          scoreResults, EvolutionaryCharacteristic.knowledgeManagement.name),
      marketPerception: _parseScore(
          scoreResults, EvolutionaryCharacteristic.marketPerception.name),
      userPerception: _parseScore(
          scoreResults, EvolutionaryCharacteristic.userPerception.name),
      perceptionInIndustry: _parseScore(
          scoreResults, EvolutionaryCharacteristic.perceptionInIndustry.name),
      focusOfValue: _parseScore(
          scoreResults, EvolutionaryCharacteristic.focusOfValue.name),
      understanding: _parseScore(
          scoreResults, EvolutionaryCharacteristic.understanding.name),
      comparison:
          _parseScore(scoreResults, EvolutionaryCharacteristic.comparison.name),
      failure:
          _parseScore(scoreResults, EvolutionaryCharacteristic.failure.name),
      marketAction: _parseScore(
          scoreResults, EvolutionaryCharacteristic.marketAction.name),
      efficiency:
          _parseScore(scoreResults, EvolutionaryCharacteristic.efficiency.name),
      decisionDrivers: _parseScore(
          scoreResults, EvolutionaryCharacteristic.decisionDrivers.name),
    );
  }
}

class ManyShotPromptStrategy extends PromptStrategy {
  @override
  Future<EvolutionScore> prompt(BaseChatModel<ChatModelOptions> model,
      Concept concept, ScorePrompts prompts) async {
    var scores = <EvolutionaryCharacteristic, CharacteristicScore>{};
    for (var characteristic in EvolutionaryCharacteristic.values) {
      var prompt = await prompts.toScore({characteristic}, concept);
      print(prompt);
      var result = await model.invoke(prompt);
      print(result);
      var scoreResults = jsonDecode(result.outputAsString);
      scores[characteristic] = _parseScore(scoreResults, characteristic.name);
    }
    return EvolutionScore(
        ubiquity: scores[EvolutionaryCharacteristic.ubiquity]!,
        certainty: scores[EvolutionaryCharacteristic.certainty]!,
        publicationTypes: scores[EvolutionaryCharacteristic.publicationTypes]!,
        market: scores[EvolutionaryCharacteristic.market]!,
        knowledgeManagement:
            scores[EvolutionaryCharacteristic.knowledgeManagement]!,
        marketPerception: scores[EvolutionaryCharacteristic.marketPerception]!,
        userPerception: scores[EvolutionaryCharacteristic.userPerception]!,
        perceptionInIndustry:
            scores[EvolutionaryCharacteristic.perceptionInIndustry]!,
        focusOfValue: scores[EvolutionaryCharacteristic.focusOfValue]!,
        understanding: scores[EvolutionaryCharacteristic.understanding]!,
        comparison: scores[EvolutionaryCharacteristic.comparison]!,
        failure: scores[EvolutionaryCharacteristic.failure]!,
        marketAction: scores[EvolutionaryCharacteristic.marketAction]!,
        efficiency: scores[EvolutionaryCharacteristic.efficiency]!,
        decisionDrivers: scores[EvolutionaryCharacteristic.decisionDrivers]!);
  }
}

CharacteristicScore _parseScore(
    Map<String, dynamic> scoreResults, String characteristic) {
  var score = scoreResults[characteristic]['score'];
  score ??= scoreResults[characteristic.toLowerCase()]['score'];
  return CharacteristicScore(score);
}
