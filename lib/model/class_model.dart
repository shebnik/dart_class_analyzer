/// A data class representing information about a Dart class and its methods.
///
/// Instances of this class provide a convenient way to store and access
/// details about a Dart class, including its name and the count of methods it 
/// has.
class ClassModel {
  /// Creates a new instance of [ClassModel] with the given class name and 
  /// method count.
  const ClassModel({
    required this.className,
    required this.methodCount,
  });

  /// The name of the Dart class.
  final String className;

  /// The number of methods in the Dart class.
  final int methodCount;
}
