import 'package:langchain/langchain.dart';

import 'evolution_rater.dart';
import 'evolution_score.dart';

abstract class ScorePrompts {
  Future<PromptValue> toScore(
      Set<EvolutionaryCharacteristic> characteristic, Concept concept);
}

class DefaultPrompts extends ScorePrompts {
  final Elaboration elaboration;

  DefaultPrompts({this.elaboration = Elaboration.briefReason});

  @override
  Future<PromptValue> toScore(
      Set<EvolutionaryCharacteristic> characteristic, Concept concept) {
    return Future.value(_scoreConcept
        .formatPrompt({
          'concept': concept.name,
        })
        .concat(elaboration == Elaboration.briefReason
            ? _explainWithReason
            : _explainNoReason)
        .concat(characteristic.map((c) {
          return _scoreCharacteristic.formatPrompt({
            'characteristic': c.name,
            'stage1': c.stages[0],
            'stage2': c.stages[1],
            'stage3': c.stages[2],
            'stage4': c.stages[3],
          });
        }).reduce((p1, p2) => p1.concat(p2))));
  }
}

enum Elaboration {
  none,
  briefReason,
}

final _scoreConcept = PromptTemplate.fromTemplate(
    '''Please score the concept "{concept}" on its evolutionary characteristics. 
Evolution is a continuous measure of certainty broken into 4 stages (phase changes), from least certain, most novel and surprising, to the most certain, ubiquitous, and well understood.
Evaluate evolution only by its constituent characteristics, each with a score from 1 to 5 (with fractional component).
1 to 2 corresponds to stage 1, 2 to 3 corresponds to stage 2, 3 to 4 corresponds to stage 3, and 4 to 5 corresponds to stage 4.
I will list each characteristic with a description of its stages, and you will provide a score for each.
Evaluate each characteristic independently such that it is scored in context of the stages for that characteristic alone.''');

final _explainWithReason = PromptValue.string('''
Respond with JSON in the form of {"characteristic": {"score": score, "reason": "..."}}.
Keep the reasons for each characteristic score brief.

''');
final _explainNoReason = PromptValue.string(
    '''Respond with JSON in the form of {"characteristic": {"score": score}}.

''');

final _scoreCharacteristic =
    PromptTemplate.fromTemplate('''Characteristic: "{characteristic}":
Stage 1 (score 1 to 2): {stage1}
Stage 2 (score 2 to 3): {stage2}
Stage 3 (score 3 to 4): {stage3}
Stage 4 (score 4 to 5): {stage4}

''');
