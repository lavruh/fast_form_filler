import 'package:fast_form_filler/domain/show_port.dart';

class Field {
  final String id;
  final String title;
  final String data;
  final List<ShowPort> showPorts;
  final FieldType fieldType;

  const Field({
    required this.id,
    required this.title,
    required this.data,
    required this.showPorts,
    required this.fieldType,
  });

  Field.empty()
      : id = DateTime.now().millisecondsSinceEpoch.toString(),
        title = "",
        data = "",
        showPorts = [],
        fieldType = FieldType.sameEveryPrint;

  Field copyWith({
    String? id,
    String? title,
    String? data,
    List<ShowPort>? showPorts,
    FieldType? fieldType,
  }) {
    return Field(
      id: id ?? this.id,
      title: title ?? this.title,
      data: data ?? this.data,
      showPorts: showPorts ?? this.showPorts,
      fieldType: fieldType ?? this.fieldType,
    );
  }
}

enum FieldType { sameEveryPrint, increasingByPrint, decreasingByPrint }