import 'dart:io';

import 'package:args/args.dart';
import 'package:langchain_openai/langchain_openai.dart';
import 'package:map_minder/evolution_rater.dart';
import 'package:map_minder/genai_prompts.dart';
import 'package:map_minder/genai_evolution_rater.dart';

const String version = '0.0.1';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Show additional command output.',
    )
    ..addFlag(
      'version',
      negatable: false,
      help: 'Print the tool version.',
    );
}

void printUsage(ArgParser argParser) {
  print('Usage: dart map_minder.dart <flags> [arguments]');
  print(argParser.usage);
}

void main(List<String> arguments) async {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);
    bool verbose = false;

    // Process the parsed arguments.
    if (results.wasParsed('help')) {
      printUsage(argParser);
      return;
    }
    if (results.wasParsed('version')) {
      print('map_minder version: $version');
      return;
    }
    if (results.wasParsed('verbose')) {
      verbose = true;
    }

    var apiKey = Platform.environment['OPENAI_MAP_MINDER_KEY'];
    var llm = ChatOpenAI(
        apiKey: apiKey,
        defaultOptions: ChatOpenAIOptions(
            model: 'gpt-4o',
            temperature: 0.5,
            responseFormat: ChatOpenAIResponseFormat(
                type: ChatOpenAIResponseFormatType.jsonObject)));
    var prompts = DefaultPrompts();
    var rater = GenAiEvolutionRater(llm, prompts);
    var score = await rater.score(Concept(results.rest.join(' ')));
    print(score);
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
  }
}
