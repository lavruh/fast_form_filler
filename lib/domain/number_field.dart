import 'package:fast_form_filler/domain/field.dart';

class NumberField extends Field {
  NumberField({
    super.id,
    required super.title,
    required super.data,
    required super.showPorts,
    required super.fieldType,
    super.dataType = FieldDataType.number,
  });

  @override
  String? validateField(String? val) {
    if (val == null || int.tryParse(val) == null) return "Incorrect integer";
    return null;
  }

  @override
  Field iterateValue() {
    final i = int.tryParse(data);
    if (i != null) {
      if (fieldType == FieldType.increasing) {
        return copyWith(data: "${i + 1}");
      }
      if (fieldType == FieldType.decreasing) {
        return copyWith(data: "${i - 1}");
      }
    }
    return copyWith(data: data);
  }
}
