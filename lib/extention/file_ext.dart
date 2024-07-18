import 'dart:io';

extension FileExt on File {
  Future<void> createFile() async {
    if (!(await exists())) {
      await create(recursive: true);
    }
  }
}
