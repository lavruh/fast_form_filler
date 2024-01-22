import 'package:fast_form_filler/domain/fields_controller.dart';
import 'package:fast_form_filler/domain/show_port.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowPortWidget extends StatelessWidget {
  const ShowPortWidget({super.key, required this.port, required this.label});
  final ShowPort port;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GetX<FieldsController>(builder: (state) {
      return Positioned(
        left: port.position.left,
        top: port.position.top,
        child: SizedBox(
          width: port.position.width,
          height: port.position.height,
          child: Container(
            color: state.selectedShowPort == port ? Colors.red : Colors.grey,
            child: TextButton(
                onPressed: () => state.selectShowPort(port),
                child: Text("$label : ${port.id}")),
          ),
        ),
      );
    });
  }
}
