import 'dart:io';
import 'package:fast_form_filler/domain/field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:printing/printing.dart';

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
    final filePath = f?.paths.first;
    if (filePath != null) {
      final tmpDir = await getTemporaryDirectory();
      final tmpPath = p.join(tmpDir.path, "tmp.pdf");
      final templatePath = p.join(tmpDir.path, "template.pdf");
      await File(filePath).copy(tmpPath);
      await File(filePath).copy(templatePath);
      file = File(tmpPath);
      _template.value = [File(templatePath)];
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
          pdf.pages[port.page - 1].graphics.drawString(
              field.data, PdfStandardFont(PdfFontFamily.timesRoman, 12),
              bounds: port.position);
        }
      }
      await file!.writeAsBytes(pdf.saveSync());
      final tmp = file;
      file = tmp;
    } on Exception catch (message) {
      Get.snackbar("Error", message.toString());
    }
  }
}
