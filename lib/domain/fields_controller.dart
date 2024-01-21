import 'package:fast_form_filler/domain/field.dart';
import 'package:get/get.dart';

class FieldsController extends GetxController {
  final fields = <Field>[].obs;
  final _fieldToEdit = <Field>[].obs;

  Field? get fieldToEdit {
    if (_fieldToEdit.isEmpty) {
      return null;
    }
    return _fieldToEdit[0];
  }

  openEditor(Field field) {
    _fieldToEdit.clear();
    _fieldToEdit.add(field);
  }

  closeEditor() {
    _fieldToEdit.clear();
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
