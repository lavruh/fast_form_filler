import 'package:fast_form_filler/domain/file_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FieldsMenu extends StatelessWidget {
  const FieldsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text("Fields"),
          subtitle: Row(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
              IconButton(
                  onPressed: () {
                    Get.find<FileController>().printExistingPdf();
                  },
                  icon: const Icon(Icons.print)),
            ],
          ),
        )
      ],
    );
  }
}
