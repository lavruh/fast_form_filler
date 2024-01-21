import 'dart:io';
import 'package:fast_form_filler/domain/field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:printing/printing.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class FileController extends GetxController {
  final _file = <File>[].obs;
  final _template = <File>[].obs;

  File? get file => _file.isNotEmpty ? _file.first : null;

  set file(File? val) {
    _file.clear();
    if (val != null) {
      _file.add(val);
    }
  }

  openPdfFile() async {
    final f = await FilePicker.platform.pickFiles(allowedExtensions: ['pdf']);
    if (kIsWeb) {
      _loadWebFile(f);
    } else {
      _openFileDesktop(f);
    }
    _template.value = _file;
  }

  _loadWebFile(FilePickerResult? f) async {
    final buffer = f?.files.first.bytes;
    if (buffer != null) {
      file = File.fromRawPath(buffer);
    }
  }

  _openFileDesktop(FilePickerResult? f) async {
    final filePath = f?.paths.first;
    if (filePath != null) {
      final tmpDir = await getTemporaryDirectory();
      final tmpPath = p.join(tmpDir.path, "tmp.pdf");
      File(filePath).copy(tmpPath);
      file = File(tmpPath);
    }
  }

  printExistingPdf() async {
    final pdf = file;
    if (pdf != null) {
      await Printing.layoutPdf(onLayout: (_) => pdf.readAsBytesSync());
    }
  }

  updatePdfWithFields(List<Field> fields) async {
    try {
      if (_template.isEmpty || file == null) {
        throw Exception("Open file first");
      }
      final buffer = await _template.first.readAsBytes();
      final pdf = PdfDocument(inputBytes: buffer);

      for (final field in fields) {
        for (final port in field.showPorts) {
          pdf.pages[port.page].graphics.drawString(
              field.data, PdfStandardFont(PdfFontFamily.timesRoman, 12),
              bounds: port.position);
        }
      }
      file!.writeAsBytes(pdf.saveSync());
      final tmp = file;
      file = tmp;
    } on Exception catch (message) {
      Get.snackbar("Error", message.toString());
    }
  }
}
