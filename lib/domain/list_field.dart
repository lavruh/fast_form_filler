import 'package:fast_form_filler/domain/field.dart';

class ListField extends Field {
  final List<String> values;

  ListField({
    super.id,
    required super.title,
    required super.data,
    required super.showPorts,
    required super.fieldType,
    super.dataType = FieldDataType.list,
    required this.values,
  });

  @override
  String? validateField(String? val) {
    if (!values.contains(val)) {
      return "Is not valid value";
    }
    return null;
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({"values": values});
    return map;
  }
}
