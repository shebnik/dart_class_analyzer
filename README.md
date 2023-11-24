# Dart Class Analyzer

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![License: MIT][license_badge]][license_link]

Dart Class Analyzer is a Dart package that provides tools for analyzing Dart classes and methods in a project. It helps you understand the structure of your codebase by counting methods in classes and provides insights into your project's organization.

## Table of Contents

- [Introduction](#dart-class-analyzer)
- [Installation](#installation-💻)
- [Usage](#usage)
  - [Count Methods in Folder](#count-methods-in-folder)
  - [Count Methods in Class](#count-methods-in-class)
  - [Analyze Class](#analyze-class)
- [Continuous Integration](#continuous-integration-🤖)
- [Running Tests](#running-tests-🧪)
- [Contributing](#contributing)
- [License](#license)

## Installation 💻

**❗ In order to start using Dart Class Analyzer, you must have the [Dart SDK][dart_install_link] installed on your machine.**

### Use it as a CLI

Activate the package with:

```sh
dart pub global activate dart_class_analyzer
```

### Use it as a library

Install via `dart pub add`:

```sh
dart pub add dart_class_analyzer
```

---

### Usage

### Use it as a CLI

Count the methods in a project with:
```sh
method_counter [options] <project_lib_path>
```

### Use it as an library

1. Import the `dart_class_analyzer` package.

```dart
import 'package:dart_class_analyzer/dart_class_analyzer.dart';
```

2. Create an instance of `DartClassAnalyzer`.

```dart
final analyzer = DartClassAnalyzer();
```

#### Count Methods in Folder
Use the `countMethodsInFolder` method to analyze Dart files in a folder.

```dart
final pathToDartFiles = 'path/to/your/dart/files';
final classes = analyzer.countMethodsInFolder(pathToDartFiles);

for (final classModel in classes) {
  print('${classModel.className} has ${classModel.methodCount} methods');
}
```

This will print information about each class in the specified folder, including the class name and the number of methods it has.

Remember to replace `'path/to/your/dart/files'` with the actual path to your Dart files, and adjust the code examples based on your project structure.

#### Count Methods in Class
Use `countMethodsInClass` to analyze a single Dart class represented by code.

```dart
final dartCode = '''
  class MyClass {
    void method1() {}
    void method2() {}
  }
''';

final classModel = analyzer.countMethodsInClass(dartCode);

if (classModel != null) {
  print('${classModel.className} has ${classModel.methodCount} methods');
}
```

This will print information about the specified class.

#### Analyze Class
If you have a Dart class and want to analyze its methods using reflection, you can use the `analyzeClass` method.

```dart
class MyClass {
  void method1() {}
  void method2() {}
}

final methodCount = analyzer.analyzeClass(MyClass);
print('MyClass has $methodCount methods');
```

This will print the total number of methods in the specified class.

## Continuous Integration 🤖

Dart Class Analyzer comes with a built-in [GitHub Actions workflow][github_actions_link] powered by [Very Good Workflows][very_good_workflows_link]. You can also integrate it with your preferred CI/CD solution.

On each pull request and push, the CI pipeline performs code formatting, linting, and testing to ensure code consistency and correctness. The project adheres to [Very Good Analysis][very_good_analysis_link] for strict analysis options. Code coverage is monitored using [Very Good Coverage][very_good_coverage_link].

---

## Running Tests 🧪

To run all unit tests:

```sh
dart pub global activate coverage 1.2.0
dart test --coverage=coverage
dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info
```

To view the generated coverage report, you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
open coverage/index.html
```

## Contributing

If you would like to contribute to the project, follow these steps:

1. Fork the project.
2. Create your feature branch (`git checkout -b feature/YourFeature`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature/YourFeature`).
5. Open a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

[dart_install_link]: https://dart.dev/get-dart
[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_coverage_link]: https://github.com/marketplace/actions/very-good-coverage