import 'dart:convert';
import 'package:fast_form_filler/domain/date_field.dart';
import 'package:fast_form_filler/domain/number_field.dart';
import 'package:fast_form_filler/domain/show_port.dart';
import 'package:fast_form_filler/domain/string_field.dart';

class Field {
  final String id;
  final String title;
  final String data;
  final List<ShowPort> showPorts;
  final FieldType fieldType;
  final FieldDataType dataType;

  Field({
    String? id,
    this.title = "",
    this.data = "",
    List<ShowPort>? showPorts,
    this.fieldType = FieldType.same,
    this.dataType = FieldDataType.string,
  })  : id = id ?? _generateId(),
        showPorts = showPorts ?? [];

  static String _generateId() =>
      DateTime.now().millisecondsSinceEpoch.toString();

  Field.empty()
      : id = _generateId(),
        title = "",
        data = "",
        showPorts = [],
        fieldType = FieldType.same,
        dataType = FieldDataType.string;

  Field copyWith(
      {String? id,
      String? title,
      String? data,
      List<ShowPort>? showPorts,
      FieldType? fieldType,
      FieldDataType? dataType}) {
    final t = dataType ?? this.dataType;
    if (t == FieldDataType.number) {
      return NumberField(
          id: id ?? this.id,
          title: title ?? this.title,
          data: data ?? this.data,
          showPorts: showPorts ?? this.showPorts,
          fieldType: fieldType ?? this.fieldType);
    }
    if (t == FieldDataType.date) {
      return DateField(
          id: id ?? this.id,
          title: title ?? this.title,
          data: data ?? this.data,
          showPorts: showPorts ?? this.showPorts,
          fieldType: fieldType ?? this.fieldType);
    }
    return StringField(
        id: id ?? this.id,
        title: title ?? this.title,
        data: data ?? this.data,
        showPorts: showPorts ?? this.showPorts,
        fieldType: fieldType ?? this.fieldType);
  }

  String toJson() {
    final d = {
      'id': id,
      'title': title,
      'data': data,
      'showPorts': showPorts.map((showPort) => showPort.toJson()).toList(),
      'fieldType': fieldType.toString(),
      'dataType': dataType.toString(),
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

    final f = Field(
      id: json['id'] as String,
      title: json['title'] as String,
      data: json['data'] as String,
      showPorts: ports,
      fieldType: FieldType.values.firstWhere(
          (e) => e.toString() == json['fieldType'],
          orElse: () => FieldType.same),
      dataType: FieldDataType.values.firstWhere(
          (e) => e.toString() == json['dataType'],
          orElse: () => FieldDataType.string),
    );

    return f.copyWith();
  }

  String? validateField(String? val) => null;

  Field iterateValue() => copyWith();
}

enum FieldType { same, increasing, decreasing }

enum FieldDataType { string, number, date }
