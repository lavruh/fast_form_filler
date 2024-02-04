import 'dart:convert';
import 'package:fast_form_filler/domain/show_port.dart';
import 'package:intl/intl.dart';

class Field {
  final String id;
  final String title;
  final String data;
  final List<ShowPort> showPorts;
  final FieldType fieldType;
  final FieldDataType dataType;
  final _dateStringFormat = "dd-MM-yyyy";

  const Field({
    required this.id,
    required this.title,
    required this.data,
    required this.showPorts,
    required this.fieldType,
    required this.dataType,
  });

  Field.empty()
      : id = DateTime.now().millisecondsSinceEpoch.toString(),
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
    return Field(
      id: id ?? this.id,
      title: title ?? this.title,
      data: data ?? this.data,
      showPorts: showPorts ?? this.showPorts,
      fieldType: fieldType ?? this.fieldType,
      dataType: dataType ?? this.dataType,
    );
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

    return Field(
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
  }

  String? validateField(String? val) {
    if (dataType == FieldDataType.number) {
      if (val == null || int.tryParse(val) == null) return "Incorrect integer";
    }
    if (dataType == FieldDataType.date) {
      if (val == null || DateFormat(_dateStringFormat).tryParse(val) == null) {
        return "Incorrect Date, Should be [dd-mm-yyyy]";
      }
    }
    return null;
  }

  Field iterateValue() {
    if (dataType == FieldDataType.number) {
      final i = int.tryParse(data);
      if (i != null) {
        if (fieldType == FieldType.increasing) {
          return copyWith(data: "${i + 1}");
        }
        if (fieldType == FieldType.decreasing) {
          return copyWith(data: "${i - 1}");
        }
      }
    }
    if (dataType == FieldDataType.date) {
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
    }
    return copyWith(data: data);
  }
}

enum FieldType { same, increasing, decreasing }

enum FieldDataType { string, number, date }
