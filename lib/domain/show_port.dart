import 'dart:convert';
import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart';

class ShowPort {
  final String id;
  final int page;
  final Rect position;
  final int fontSize;
  final PdfFontFamily font; // New field

  const ShowPort({
    required this.id,
    required this.page,
    required this.position,
    required this.fontSize,
    required this.font,
  });

  @override
  String toString() {
    return '\nShowPort{id: $id, page: $page, position: $position, fontSize: $fontSize, font: $font}\n';
  }

  ShowPort.empty({required this.id})
      : page = 0,
        position = const Rect.fromLTWH(00, 00, 800, 200),
        fontSize = 10,
        font = PdfFontFamily.timesRoman;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShowPort &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          page == other.page &&
          position == other.position &&
          fontSize == other.fontSize &&
          font == other.font;

  @override
  int get hashCode =>
      id.hashCode ^
      page.hashCode ^
      position.hashCode ^
      fontSize.hashCode ^
      font.hashCode;

  // Default font and size

  ShowPort copyWith({
    String? id,
    int? page,
    Rect? position,
    int? fontSize,
    PdfFontFamily? font,
  }) {
    return ShowPort(
      id: id ?? this.id,
      page: page ?? this.page,
      position: position ?? this.position,
      fontSize: fontSize ?? this.fontSize,
      font: font ?? this.font,
    );
  }

  String toJson() {
    final data = {
      'id': id,
      'page': page,
      'position': {
        'left': position.left,
        'top': position.top,
        'width': position.width,
        'height': position.height,
      },
      'fontSize': fontSize,
      'font': font.index, // Convert enum to string
    };
    return jsonEncode(data);
  }

  factory ShowPort.fromJson(String jsonString) {
    final json = jsonDecode(jsonString);
    return ShowPort(
      id: json['id'] as String,
      page: json['page'] as int,
      position: Rect.fromLTWH(
        json['position']['left'] as double,
        json['position']['top'] as double,
        json['position']['width'] as double,
        json['position']['height'] as double,
      ),
      fontSize: json['fontSize'] as int? ?? 10,
      font: PdfFontFamily.values.firstWhere((e) => e.index == json['font'],
          orElse: () => PdfFontFamily.timesRoman),
    );
  }
}
