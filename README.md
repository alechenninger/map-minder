# Map Minder

This is a simple POC which demonstrates using LLMs to automate mediating assessments of Simon Wardley's evolutionary characteristics cheat-sheet, in order to provide some guidance when trying to determine a component's placement on the evolution axis of a Wardley Map.

```shell
$ dart bin/map_minder.dart "LLM-assisted wardley mapping"
EvolutionScore{ubiquity: 2.5, certainty: 2.5, publicationTypes: 2.8, market: 2.7, knowledgeManagement: 3.2, marketPerception: 2.5, userPerception: 2.5, perceptionInIndustry: 2.3, focusOfValue: 2.5, understanding: 2.5, comparison: 2.5, failure: 2.7, marketAction: 2.8, efficiency: 2.7, decisionDrivers: 2.8, averageScore: 2.6333333333333333}
```

Usage:

- Set your OpenAI API key via environment variable OPENAI_MAP_MINDER_KEY
  - It is currently hard coded to use the gpt-4o model, so this must be allowed
- Pass a concept via CLI and watch it grade: `dart bin/map_minder.dart "tea (in the context of a tea shop)"`

Limitations:

- The LLM does not have full context of the map or even the anchor unless you describe that in the concept prompt
- There are various strategies for prompting which may produce better or worse results, or consume more or less tokens. Swapping these requires changing the code currently.
