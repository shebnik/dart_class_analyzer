import 'dart:io';

import 'package:args/args.dart';
import 'package:dart_class_analyzer/dart_class_analyzer.dart';
import 'package:logging/logging.dart';

void main(List<String> arguments) {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  final log = Logger('method_counter');

  final argParser = ArgParser()
    ..addFlag('output', abbr: 'o', help: 'Enable output')
    ..addFlag('generated', abbr: 'g', help: 'Enable generated')
    ..addFlag('help', abbr: 'h', help: 'Show usage help');

  ArgResults argResults;

  try {
    argResults = argParser.parse(arguments);
  } catch (e) {
    log.severe('Error parsing arguments', e);
    exit(1);
  }

  if (argResults['help'] as bool) {
    log.info(argParser.usage);
    exit(0);
  }

  if (argResults.rest.isEmpty) {
    log.info('Usage: count_methods [options] <project_lib_path>');
    exit(1);
  }

  final projectPath = argResults.rest[0];

  try {
    final classModelList = DartClassAnalyzer().countMethodsInFolder(
      projectPath,
      enableGenerated: argResults['generated'] as bool? ?? true,
      output: argResults['output'] as bool? ?? false,
    );

    var totalMethods = 0;
    for (final classModel in classModelList) {
      totalMethods += classModel.methodCount;
    }

    log.info('Number of methods in $projectPath: $totalMethods');
  } catch (e) {
    log.severe('Error:', e);
    exit(1);
  }
}
