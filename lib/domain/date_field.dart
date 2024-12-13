
import 'package:fast_form_filler/domain/field.dart';
import 'package:intl/intl.dart';

class DateField extends Field {
  final _dateStringFormat = "dd-MM-yyyy";

  DateField({
    super.id,
    required super.title,
    required super.data,
    required super.showPorts,
    required super.fieldType,
    super.dataType = FieldDataType.date,
  });

  @override
  String? validateField(String? val) {
    if (val == null || DateFormat(_dateStringFormat).tryParse(val) == null) {
      return "Incorrect Date, Should be [dd-mm-yyyy]";
    }
    return null;
  }

  @override
  Field iterateValue() {
    final d = DateFormat(_dateStringFormat).tryParse(data);
    if (d != null) {
      if (fieldType == FieldType.increasing) {
        final newDate = d.add(const Duration(days: 1));
        return copyWith(data: DateFormat(_dateStringFormat).format(newDate));
      }
      if (fieldType == FieldType.decreasing) {
        final newDate = d.subtract(const Duration(days: 1));
        return copyWith(data: DateFormat(_dateStringFormat).format(newDate));
      }
    }
    return copyWith(data: data);
  }
}