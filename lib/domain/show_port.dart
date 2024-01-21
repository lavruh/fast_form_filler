import 'dart:ui';

class ShowPort{
  final int page;
  final Rect position;

  const ShowPort({
    required this.page,
    required this.position,
  });

  ShowPort copyWith({
    int? page,
    Rect? position,
  }) {
    return ShowPort(
      page: page ?? this.page,
      position: position ?? this.position,
    );
  }
}