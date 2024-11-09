import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:archive/archive_io.dart';
import 'package:fast_form_filler/domain/field.dart';
import 'package:fast_form_filler/domain/fields_controller.dart';
import 'package:fast_form_filler/domain/show_port.dart';
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
      _openFilePath(filePath: filePath);
    }
  }

  _openFilePath({required String filePath}) async {
    final tmpDir = await getTemporaryDirectory();
    final tmpPath = p.join(tmpDir.path, "tmp.pdf");
    final templatePath = p.join(tmpDir.path, "template.pdf");
    await File(filePath).copy(tmpPath);
    await File(filePath).copy(templatePath);
    file = File(tmpPath);
    _template.value = [File(templatePath)];
  }

  printExistingPdf() async {
    final pdf = file;
    if (pdf != null) {
      await Printing.layoutPdf(onLayout: (_) => pdf.readAsBytesSync());
    }
  }

  saveOutputPdfFile() async {
    final pdf = file;
    final f = await FilePicker.platform.saveFile(allowedExtensions: ['pdf']);
    if (f == null || pdf == null) return;
    pdf.copy(f);
  }

  createFileFromIteratingFields({
    int numberOfIterations = 1,
    List<int> pagesToIterate = const [1],
  }) async {
    if (_template.isEmpty || file == null) {
      throw Exception("Open file first");
    }
    final fieldsController = Get.find<FieldsController>();
    final buffer = await _template.first.readAsBytes();
    final pdf = PdfDocument(inputBytes: buffer);

    final List<Field> fieldsOnPage = [];
    List<PdfTemplate> templates = [];
    for (final pageNo in pagesToIterate) {
      try {
        final page = pdf.pages[pageNo - 1];
        final template = page.createTemplate();
        templates.add(template);
        fieldsOnPage
            .addAll(fieldsController.getFieldsPlacedOnPage(page: pageNo));
      } on Exception {
        throw Exception("Wrongly selected pages");
      }
    }

    _iterateFieldsAndPorts(
        fields: fieldsOnPage,
        condition: (page) => pdf.pages.count >= page,
        action: (field, port) {
          final page = pdf.pages[port.page - 1];
          _updatePdfFieldData(page, field, port);
        });

    final rightMargin = pdf.pageSettings.margins.right;
    final topMargin = pdf.pageSettings.margins.top;

    List<Field> fields = [];
    for (int i = 0; i < numberOfIterations; i++) {
      if (i == 0) {
        fields = fieldsOnPage;
      }
      fields = fieldsController.iterateFields(fields);
      for (final pageNo in pagesToIterate) {
        final template = templates[pageNo - 1];
        final page = pdf.pages.add();
        page.graphics
            .drawPdfTemplate(template, Offset(-rightMargin, -topMargin));
        _iterateFieldsAndPorts(
            fields: fields,
            condition: (page) => pageNo == page,
            action: (field, port) {
              final pos = port.position;
              final p = port.copyWith(
                  position: Rect.fromLTWH(pos.left - rightMargin,
                      pos.top - topMargin, pos.width, pos.height));
              _updatePdfFieldData(page, field, p);
            });
      }
    }

    await file!.writeAsBytes(pdf.saveSync());
    final tmp = file;
    file = tmp;
  }

  _iterateFieldsAndPorts({
    required List<Field> fields,
    required bool Function(int page) condition,
    required Function(Field, ShowPort) action,
  }) {
    for (final field in fields) {
      for (final port in field.showPorts) {
        if (condition(port.page)) {
          action(field, port);
        }
      }
    }
  }

  Future<List<int>> _updatePdfBuffer(
    List<Field> fields,
    Function(PdfPage, Field, ShowPort) updateAction,
  ) async {
    if (_template.isEmpty || file == null) {
      throw Exception("Open file first");
    }
    final buffer = await _template.first.readAsBytes();
    final pdf = PdfDocument(inputBytes: buffer);

    _iterateFieldsAndPorts(
        fields: fields,
        condition: (page) => pdf.pages.count >= page,
        action: (field, port) {
          final page = pdf.pages[port.page - 1];
          updateAction(page, field, port);
        });

    return pdf.saveSync();
  }

  _updatePdfFieldData(PdfPage page, Field field, ShowPort port) {
    page.graphics.drawString(
        field.data, PdfStandardFont(port.font, port.fontSize.toDouble()),
        bounds: port.position);
  }

  _updatePdfFieldIndicator(PdfPage page, Field field, ShowPort port) {
    page.graphics.drawString(
        port.id, PdfStandardFont(port.font, port.fontSize.toDouble()),
        brush: PdfBrushes.red, bounds: port.position);
  }

  updatePdfWithFields(List<Field> fields) async {
    try {
      final buffer = await _updatePdfBuffer(fields, _updatePdfFieldData);
      await file!.writeAsBytes(buffer);
      final tmp = file;
      file = tmp;
    } on Exception {
      rethrow;
    }
  }

  updateFieldsIndicators(Field field) async {
    try {
      final buffer = await _updatePdfBuffer([field], _updatePdfFieldIndicator);
      await file!.writeAsBytes(buffer);
      final tmp = file;
      file = tmp;
    } on Exception catch (message) {
      Get.snackbar("Error", message.toString());
    }
  }

  Future<void> saveTemplate() async {
    try {
      final fieldsJsonString =
          Get.find<FieldsController>().saveFieldsDataAsJson();

      final templateFile = _template[0];

      final tmpDirPath = await getTemporaryDirectory();
      final zipFilePath = p.join(tmpDirPath.path, "template.zip");

      final archive = Archive()
        ..addFile(ArchiveFile(p.basename(templateFile.path),
            templateFile.lengthSync(), await templateFile.readAsBytes()))
        ..addFile(ArchiveFile('fields.json', fieldsJsonString.length,
            utf8.encode(fieldsJsonString)));

      final zipFile = File(zipFilePath);
      final buffer = ZipEncoder().encode(archive);
      if (buffer == null) {
        throw Exception("Can not encode data");
      }
      await zipFile.writeAsBytes(buffer);

      final savePath = await FilePicker.platform
          .saveFile(allowedExtensions: ["fff"], type: FileType.custom);
      if (savePath != null) {
        final saveFile = File(savePath);
        await zipFile.copy(saveFile.path);
        Get.snackbar('Success', 'Template saved successfully');
      }
    } catch (error) {
      Get.snackbar('Error', error.toString());
    }
  }

  Future<void> openTemplate() async {
    try {
      final selectedFiles = await FilePicker.platform.pickFiles(
        allowedExtensions: ['fff'],
        type: FileType.custom,
      );

      if (selectedFiles == null || selectedFiles.files.isEmpty) {
        throw Exception("No file selected");
      }

      final templateFile = File(selectedFiles.files.single.path!);

      final archiveBytes = await templateFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(archiveBytes);

      ArchiveFile? templateArchiveFile;
      ArchiveFile? fieldsJsonArchiveFile;

      for (final file in archive) {
        if (file.name == 'fields.json') {
          fieldsJsonArchiveFile = file;
        } else if (file.name.endsWith('.pdf')) {
          templateArchiveFile = file;
        }
      }

      if (templateArchiveFile == null || fieldsJsonArchiveFile == null) {
        throw Exception("Invalid template file format");
      }

      final tmpDirPath = await getTemporaryDirectory();

      final templatePath = p.join(tmpDirPath.path, templateArchiveFile.name);
      await File(templatePath)
          .writeAsBytes(templateArchiveFile.content as List<int>);
      await _openFilePath(filePath: templatePath);

      final fieldsJsonString =
          utf8.decode(fieldsJsonArchiveFile.content as List<int>);

      Get.find<FieldsController>().loadFieldsFromJson(json: fieldsJsonString);

      Get.snackbar('Success', 'Template opened successfully');
    } catch (error) {
      Get.snackbar('Error', error.toString());
    }
  }
}
