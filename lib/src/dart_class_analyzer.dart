import 'dart:io';
import 'dart:mirrors';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_class_analyzer/model/class_model.dart';
import 'package:logging/logging.dart';

/// Dart Class Analyzer
///
/// This class provides methods for analyzing Dart classes and methods.
class DartClassAnalyzer {
  /// Create a new instance of [DartClassAnalyzer].
  DartClassAnalyzer() : _log = Logger('DartClassAnalyzer');

  final Logger _log;

  /// Count methods in the specified folder.
  ///
  /// This method analyzes all Dart files in the given folder and returns a
  /// list of [ClassModel] instances representing the classes and method counts.
  ///
  /// If [enableGenerated] is true, generated files (e.g., '.g.dart') will be
  /// included.
  List<ClassModel> countMethodsInFolder(
    String path, {
    bool enableGenerated = false,
    bool verbose = false,
  }) {
    final dir = Directory(path);
    if (!dir.existsSync()) {
      return [];
    }
    var classList = <ClassModel>[];

    final files = dir.listSync(recursive: true).whereType<File>().where((file) {
      return file.path.endsWith('.dart') &&
          (enableGenerated || !file.path.contains('.g.dart'));
    });

    for (final file in files) {
      final classModel = countMethodsInFile(file, verbose: verbose);
      if (classModel.isNotEmpty) {
        classList = [...classList, ...classModel];
      }
    }

    return classList;
  }

  /// Count methods in a Dart classes represented by the provided Dart file.
  ///
  /// This method parses the Dart code and returns a [ClassModel] instance
  /// representing the class and its method count. If no class with methods
  /// is found, it returns empty.
  List<ClassModel> countMethodsInFile(
    File file, {
    bool verbose = false,
  }) {
    final dartCode = file.readAsStringSync();
    CompilationUnit unit;
    try {
      unit = parseString(content: dartCode).unit;
    } catch (e, s) {
      if (verbose) {
        _log.severe('Error parsing file ${file.path}', e, s);
      }
      return [];
    }

    final classDeclarations = unit.declarations.whereType<ClassDeclaration>();
    if (classDeclarations.isEmpty) {
      if (verbose) {
        _log.info('No class declarations found in file ${file.path}');
      }
      return [];
    }
    var classList = <ClassModel>[];
    for (final classDeclaration in classDeclarations) {
      final classModel = ClassModel(
        className: classDeclaration.name.toString(),
        methodCount:
            classDeclaration.members.whereType<MethodDeclaration>().length,
      );
      classList = [...classList, classModel];
      if (verbose) {
        _log.info('${file.path}: $classModel');
      }
    }
    return classList;
  }

  /// Count methods in a Dart classes represented by the provided Dart code.
  ///
  /// This method parses the Dart code and returns a [ClassModel] instance
  /// representing the class and its method count. If no class with methods
  /// is found, it returns empty.
  List<ClassModel> countMethodsInString(
    String dartcode, {
    bool verbose = false,
  }) {
    final unit = parseString(content: dartcode).unit;

    final classDeclarations = unit.declarations.whereType<ClassDeclaration>();
    if (classDeclarations.isEmpty) {
      if (verbose) {
        _log.info('No class declarations found in String');
      }
      return [];
    }
    var classList = <ClassModel>[];
    for (final classDeclaration in classDeclarations) {
      final classModel = ClassModel(
        className: classDeclaration.name.toString(),
        methodCount:
            classDeclaration.members.whereType<MethodDeclaration>().length,
      );
      classList = [...classList, classModel];
      if (verbose) {
        _log.info('$classModel');
      }
    }
    return classList;
  }

  /// Analyze methods in a Dart class represented by the provided type.
  ///
  /// This method uses Dart reflection to analyze the methods of a class
  /// represented by the provided type and returns the total number of methods.
  int analyzeClass(Type cls) {
    final classMirror = reflectClass(cls);
    final methods = classMirror.declarations.values.whereType<MethodMirror>();
    return methods.length;
  }
}
