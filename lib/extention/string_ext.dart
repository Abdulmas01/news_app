extension StringExt on String {
  String get removeFileExtention => _removeFileExtention();

  String _removeFileExtention() {
    if (contains(".")) {
      List names = split(".")..removeLast();
      return names.join();
    }
    return this;
  }
}
