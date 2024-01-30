import 'dart:convert';
import 'package:fast_form_filler/domain/show_port.dart';

class Field {
  final String id;
  final String title;
  final String data;
  final List<ShowPort> showPorts;

  @override
  String toString() {
    return 'Field{id: $id, title: $title, showPorts: $showPorts, fieldType: $fieldType}';
  }

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

  String toJson() {
    final d = {
      'id': id,
      'title': title,
      'data': data,
      'showPorts': showPorts.map((showPort) => showPort.toJson()).toList(),
      'fieldType': fieldType.toString(),
    };
    return jsonEncode(d);
  }

  factory Field.fromJson(String jsonString) {
    final json = jsonDecode(jsonString);

    final portsJson = json['showPorts'];
    List<ShowPort> ports = [];

    for (final sp in portsJson) {
      ports.add(ShowPort.fromJson("$sp"));
    }

    print(portsJson);
    return Field(
      id: json['id'] as String,
      title: json['title'] as String,
      data: json['data'] as String,
      showPorts: ports,
      fieldType:
          FieldType.values.firstWhere((e) => e.toString() == json['fieldType']),
    );
  }
}

enum FieldType { sameEveryPrint, increasingByPrint, decreasingByPrint }
