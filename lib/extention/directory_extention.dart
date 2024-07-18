import 'dart:io';

extension DirectoryExt on Directory {
  Future<void> createDirectory() async {
    if (!(await exists())) {
      await create(recursive: true);
    }
  }
}
