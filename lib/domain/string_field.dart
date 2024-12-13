import 'package:fast_form_filler/domain/field.dart';

class StringField extends Field {
  StringField({
    super.id,
    required super.title,
    required super.data,
    required super.showPorts,
    required super.fieldType,
    super.dataType = FieldDataType.string,
  });

  @override
  String? validateField(String? val) {
    return null;
  }
}
