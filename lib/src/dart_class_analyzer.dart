import 'dart:io';
import 'dart:mirrors';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:collection/collection.dart';
import 'package:dart_class_analyzer/model/class_model.dart';

/// Dart Class Analyzer
///
/// This class provides methods for analyzing Dart classes and methods.
class DartClassAnalyzer {

  /// Count methods in the specified folder.
  ///
  /// This method analyzes all Dart files in the given folder and returns a
  /// list of [ClassModel] instances representing the classes and method counts.
  ///
  /// If [excludeGenerated] is true, generated files (e.g., '.g.dart') will be 
  /// excluded.
  List<ClassModel> countMethodsInFolder(
    String path, {
    bool excludeGenerated = true,
  }) {
    final dir = Directory(path);
    if (!dir.existsSync()) {
      return [];
    }
    var classCount = <ClassModel>[];

    final files = dir.listSync(recursive: true).whereType<File>().where((file) {
      return file.path.endsWith('.dart') &&
          (!excludeGenerated || !file.path.contains('.g.dart'));
    });

    for (final file in files) {
      final dartCode = file.readAsStringSync();
      final classModel = countMethodsInClass(dartCode);
      if (classModel != null) {
        classCount = [...classCount, classModel];
      }
    }

    return classCount;
  }

  /// Count methods in a Dart class represented by the provided Dart code.
  ///
  /// This method parses the Dart code and returns a [ClassModel] instance
  /// representing the class and its method count. If no class with methods
  /// is found, it returns null.
  ClassModel? countMethodsInClass(String dartCode) {
    final unit = parseString(content: dartCode).unit;

    final classDeclaration = unit.declarations
        .whereType<ClassDeclaration>()
        .firstWhereOrNull((classDeclaration) {
      return classDeclaration.members.whereType<MethodDeclaration>().isNotEmpty;
    });
    if (classDeclaration == null) {
      return null;
    }

    final methodCount =
        classDeclaration.members.whereType<MethodDeclaration>().length;
    final className = classDeclaration.name.toString();

    return ClassModel(
      className: className,
      methodCount: methodCount,
    );
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
