import 'dart:convert';
import 'dart:ui';

class ShowPort {
  final String id;
  final int page;
  final Rect position;

  const ShowPort({
    required this.id,
    required this.page,
    required this.position,
  });

  @override
  String toString() {
    return '\nShowPort{id: $id, page: $page, position: $position}\n';
  }

  ShowPort.empty({required this.id})
      : page = 0,
        position = const Rect.fromLTWH(00, 00, 800, 200);

  ShowPort copyWith({
    String? id,
    int? page,
    Rect? position,
  }) {
    return ShowPort(
      id: id ?? this.id,
      page: page ?? this.page,
      position: position ?? this.position,
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
        'height': position.height
      },
    };
    return jsonEncode(data);
  }

  factory ShowPort.fromJson(String jsonString) {
    final json = jsonDecode(jsonString);
    return ShowPort(
      id: json['id'] as String,
      page: json['page'] as int,
      position: Rect.fromLTRB(
        json['position']['left'] as double,
        json['position']['top'] as double,
        json['position']['width'] as double,
        json['position']['height'] as double,
      ),
    );
  }
}
