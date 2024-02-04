import 'package:fast_form_filler/domain/fields_controller.dart';
import 'package:fast_form_filler/domain/file_controller.dart';
import 'package:fast_form_filler/ui/field_data_form.dart';
import 'package:fast_form_filler/ui/generation_settings_dialog.dart';
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
      child: Flex(
        direction: Axis.vertical,
        children: [
          Flexible(
            flex: 1,
            child: ListTile(
              title: Row(
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
                    onPressed: () => fileController.openTemplate(),
                    icon: const Icon(Icons.folder_open),
                    tooltip: 'Open template file',
                  ),
                  IconButton(
                    onPressed: () => fileController.openPdfFile(),
                    icon: const Icon(Icons.picture_as_pdf),
                    tooltip: 'Open PDF file',
                  ),
                  IconButton(
                    onPressed: () => showGenerationSettingsDialog(context),
                    icon: const Icon(Icons.control_point_duplicate),
                    tooltip: 'Generate PDF with iterating fields',
                  ),
                  IconButton(
                    onPressed: () => fileController.saveTemplate(),
                    icon: const Icon(Icons.save),
                    tooltip: "Save template",
                  ),
                ],
              ),
            ),
          ),
          Flexible(
              flex: 5,
              child: GetX<FieldsController>(builder: (state) {
                return ListView(
                  children: state.fields
                      .map((field) => FieldDataForm(field: field))
                      .toList(),
                );
              }))
        ],
      ),
    );
  }
}
