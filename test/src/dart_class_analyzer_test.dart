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
  });
}
