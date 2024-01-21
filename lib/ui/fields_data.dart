import 'package:fast_form_filler/domain/fields_controller.dart';
import 'package:fast_form_filler/domain/file_controller.dart';
import 'package:fast_form_filler/ui/field_data_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FieldsData extends StatelessWidget {
  const FieldsData({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text("Fields"),
          subtitle: Row(
            children: [
              IconButton(
                  onPressed: () => Get.find<FieldsController>().addField(),
                  icon: const Icon(Icons.add)),
              IconButton(
                  onPressed: () =>
                      Get.find<FileController>().printExistingPdf(),
                  icon: const Icon(Icons.print)),
            ],
          ),
        ),
        GetX<FieldsController>(builder: (state) {
          return Column(
            children: state.fields
                .map((field) => FieldDataForm(field: field))
                .toList(),
          );
        })
      ],
    );
  }
}
