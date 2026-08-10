import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

abstract final class FileHelper {
  static Future<File> saveTemporary(List<int> bytes, String filename) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$filename');
    return file.writeAsBytes(bytes, flush: true);
  }

  static Future<void> open(File file) => OpenFilex.open(file.path);

  static Future<void> share(File file) => Share.shareXFiles([XFile(file.path)]);

  static Future<bool> saveToDevice(File file) async {
    final filename = file.uri.pathSegments.last;
    final extension = filename.split('.').last.toLowerCase();
    final destination = await FilePicker.platform.saveFile(
      dialogTitle: 'Save your ATSForge résumé',
      fileName: filename,
      type: FileType.custom,
      allowedExtensions: [extension],
      bytes: await file.readAsBytes(),
    );
    return destination != null;
  }
}
