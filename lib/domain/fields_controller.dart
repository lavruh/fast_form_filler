import 'dart:convert';

import 'package:fast_form_filler/domain/field.dart';
import 'package:fast_form_filler/domain/file_controller.dart';
import 'package:fast_form_filler/domain/show_port.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FieldsController extends GetxController {
  final fields = <Field>[].obs;
  final _fieldToEdit = <Field>[].obs;
  final _selectedShowPort = <ShowPort>[].obs;
  final pdfController = PdfViewerController();
  final fileState = Get.find<FileController>();
  int lastOpenPage = 1;

  Field? get fieldToEdit {
    if (_fieldToEdit.isEmpty) {
      return null;
    }
    return _fieldToEdit[0];
  }

  ShowPort? get selectedShowPort {
    if (_selectedShowPort.isEmpty) {
      return null;
    }
    return _selectedShowPort[0];
  }

  int get openedPage => pdfController.pageNumber;

  selectShowPort(ShowPort val) {
    _selectedShowPort.clear();
    _selectedShowPort.add(val);
  }

  void updateSelectedShowPort(ShowPort val) {
    final field = fieldToEdit;
    if (field == null || selectedShowPort == null) return;

    final updatedShowPorts = field.showPorts.map((sp) {
      return sp.id == val.id ? val : sp;
    }).toList();

    final updatedField = field.copyWith(showPorts: updatedShowPorts);

    _selectedShowPort.clear();
    openEditor(updatedField);
  }

  deleteShowPort(ShowPort showPort) {
    final field = fieldToEdit;
    if (field == null) return;
    field.showPorts.removeWhere((p) => p.id == showPort.id);
    openEditor(field);
  }

  openEditor(Field field) async {
    _fieldToEdit.value = [field].obs;
    await fileState.updateFieldsIndicators(field);
    update();
  }

  jumpToLastOpenedPage() {
    Future.delayed(const Duration(milliseconds: 100), () {
      pdfController.jumpToPage(lastOpenPage);
    });
  }

  closeEditor() {
    _fieldToEdit.clear();
  }

  saveState() {
    final f = fieldToEdit;
    if (f == null) return;
    updateField(f);
    closeEditor();
  }

  addField() {
    final field = Field.empty();
    fields.add(field);
    openEditor(field);
  }

  updateField(Field val) {
    final idx = fields.indexWhere((e) => e.id == val.id);
    if (idx != -1) {
      fields.removeAt(idx);
      fields.insert(idx, val);
    } else {
      fields.add(val);
    }
    fileState.updatePdfWithFields(fields);
  }

  void updatePageInformation() async {
    lastOpenPage = pdfController.pageNumber;
  }

  String saveFieldsDataAsJson() {
    final data = fields.map((field) => field.toJson()).toList();
    return jsonEncode(data);
  }

  void loadFieldsFromJson({required String json}) {
    final jsonData = jsonDecode(json);
    List<Field> loadedFields = [];
    for (final f in jsonData) {
      loadedFields.add(Field.fromJson(f));
    }
    fields.clear();
    fields.addAll(loadedFields);
    fileState.updatePdfWithFields(fields);
  }
}
