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

  ShowPort.empty()
      : id = DateTime.now().millisecondsSinceEpoch.toString(),
        page = 0,
        position = const Rect.fromLTWH(100, 100, 80, 30);

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
}
