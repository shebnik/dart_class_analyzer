// test/dart_class_analyzer_test.dart
import 'package:dart_class_analyzer/dart_class_analyzer.dart';
import 'package:test/test.dart';

void main() {
  group('DartClassAnalyzer', () {
    test('countMethodsInClass returns correct class model', () {
      final analyzer = DartClassAnalyzer();
      const code = '''
        class TestClass {
          void method1() {}
          void method2() {}
        }
      ''';
      final classModel = analyzer.countMethodsInClass(code);

      expect(classModel, isNotNull);
      expect(classModel!.className, 'TestClass');
      expect(classModel.methodCount, 2);
    });

    test('countMethodsInClass handles class without methods', () {
      final analyzer = DartClassAnalyzer();
      const code = '''
        class EmptyClass {}
      ''';
      final classModel = analyzer.countMethodsInClass(code);

      expect(classModel, isNotNull);
      expect(classModel!.className, 'EmptyClass');
      expect(classModel.methodCount, 0);
    });

    test('countMethodsInClass handles multiple methods in a class', () {
      final analyzer = DartClassAnalyzer();
      const code = '''
        class AnotherTestClass {
          void methodA() {}
          void methodB() {}
          void methodC() {}
        }
      ''';
      final classModel = analyzer.countMethodsInClass(code);

      expect(classModel, isNotNull);
      expect(classModel!.className, 'AnotherTestClass');
      expect(classModel.methodCount, 3);
    });
  });

  test('countMethodsInFolder returns correct class models', () {
    final analyzer = DartClassAnalyzer();
    final classModels = analyzer.countMethodsInFolder('test/src/test_data');

    expect(classModels, isNotNull);
    expect(classModels.length, 2);
    expect(classModels[1].className, 'TestClass');
    expect(classModels[1].methodCount, 2);
    expect(classModels[0].className, 'AnotherTestClass');
    expect(classModels[0].methodCount, 3);
  });
}
