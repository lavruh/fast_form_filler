import 'package:fast_form_filler/domain/fields_controller.dart';
import 'package:flutter/material.dart';
import 'package:fast_form_filler/domain/field.dart';
import 'package:get/get.dart';

class FieldDataForm extends StatelessWidget {
  final Field field;

  const FieldDataForm({Key? key, required this.field}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _dataController = TextEditingController(text: field.data);

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(16.0),
      child: ListTile(
        title: Text(
          field.title, // Use the title as the label text
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: TextField(
          controller: _dataController,
          decoration:
              const InputDecoration(border: InputBorder.none, hintText: 'Data'),
          onEditingComplete: () {
            final fieldsController = Get.find<FieldsController>();
            final updatedField = field.copyWith(
              data: _dataController.text,
            );
            fieldsController.updateField(updatedField);
            fieldsController.closeEditor();
          },
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => Get.find<FieldsController>().openEditor(field),
        ),
      ),
    );
  }
}
