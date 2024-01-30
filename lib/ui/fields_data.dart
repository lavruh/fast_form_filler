import 'package:fast_form_filler/domain/fields_controller.dart';
import 'package:fast_form_filler/domain/file_controller.dart';
import 'package:fast_form_filler/ui/field_data_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FieldsData extends StatelessWidget {
  const FieldsData({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Get.find<FieldsController>();
    final fileController = Get.find<FileController>();

    return Card(
      elevation: 3,
      child: Column(
        children: [
          ListTile(
            title: const Text(
              "Fields",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Row(
              children: [
                IconButton(
                  onPressed: () => state.addField(),
                  icon: const Icon(Icons.add),
                  tooltip: "Add field",
                ),
                IconButton(
                  onPressed: () => fileController.printExistingPdf(),
                  icon: const Icon(Icons.print),
                  tooltip: 'Print',
                ),
                IconButton(
                  onPressed: () => fileController.saveTemplate(),
                  icon: const Icon(Icons.save),
                  tooltip: "Save template",
                ),
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
      ),
    );
  }
}
