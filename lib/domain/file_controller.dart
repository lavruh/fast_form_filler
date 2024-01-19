import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:printing/printing.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:get/get.dart';

class FileController extends GetxController {
  final _file = <File>[].obs;

  File? get file => _file.isNotEmpty ? _file.first : null;

  set file(File? val) {
    _file.clear();
    if (val != null) {
      _file.add(val);
    }
  }

  openPdfFile() async {
    if (kIsWeb) {
      _loadWebFile();
    } else {
      _openFileDesktop();
    }
  }

  _loadWebFile() async {
    final f = await FilePicker.platform.pickFiles(allowedExtensions: ["pdf"]);
    final buffer = f?.files.first.bytes;
    if (buffer != null) {
      file = File.fromRawPath(buffer);
    }
  }

  _openFileDesktop() async {
    final f = await FilePicker.platform.pickFiles(allowedExtensions: ['pdf']);
    final filePath = f?.paths.first;
    if (filePath != null) {
      file = File(filePath);
    }
  }

  printExistingPdf() async {
    final pdf = file;
    if (pdf != null) {
      await Printing.layoutPdf(onLayout: (_) => pdf.readAsBytesSync());
    }
  }
}
