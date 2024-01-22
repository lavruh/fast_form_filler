import 'package:fast_form_filler/domain/field.dart';
import 'package:fast_form_filler/domain/show_port.dart';
import 'package:get/get.dart';

class FieldsController extends GetxController {
  final fields = <Field>[].obs;
  final _fieldToEdit = <Field>[].obs;
  final _selectedShowPort = <ShowPort>[].obs;

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
    // updateField(updatedField);
    print(updatedField);
    openEditor(updatedField);
  }

  openEditor(Field field) {
    _fieldToEdit.value = [field].obs;
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
  }
}
