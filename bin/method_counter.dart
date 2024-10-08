import 'dart:io';

import 'package:args/args.dart';
import 'package:dart_class_analyzer/dart_class_analyzer.dart';
import 'package:logging/logging.dart';

void main(List<String> arguments) {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(
    (record) {
      if (record.level > Level.INFO) {
        // ignore: lines_longer_than_80_chars, avoid_print
        print('${record.level.name}: ${record.time}: ${record.message} ${record.error} ${record.stackTrace}');
        return;
      }
      // ignore: avoid_print
      print(record.message);
    },
    onError: (Object e, StackTrace s) {
      // ignore: avoid_print
      print('Error occured: $e\n$s');
    },
  );
  final log = Logger('method_counter');

  final argParser = ArgParser()
    ..addFlag('verbose', abbr: 'v', help: 'Verbose output')
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
    final enableGenerated = argResults['generated'] as bool? ?? false;
    final verbose = argResults['verbose'] as bool? ?? false;

    final classModelList = DartClassAnalyzer().countMethodsInFolder(
      projectPath,
      enableGenerated: enableGenerated,
      verbose: verbose,
    );

    var totalMethods = 0;
    for (final classModel in classModelList) {
      totalMethods += classModel.methodCount;
    }
    if (!verbose) {
      log.info(totalMethods);
      exit(0);
    }
    log.info('Number of methods in $projectPath: $totalMethods');
  } catch (e, s) {
    log.severe('Error:', e, s);
    exit(1);
  }
}
