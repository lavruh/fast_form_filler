import 'package:fast_form_filler/domain/show_port.dart';
import 'package:flutter/material.dart';

class ShowPortWidget extends StatelessWidget {
  const ShowPortWidget({super.key, required this.port});
  final ShowPort port;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: port.position.left,
      top: port.position.top,
      child: SizedBox(
        width: port.position.width,
        height: port.position.height,
        child: TextButton(onPressed: () {}, child: Text("data")),
      ),
    );
  }
}
