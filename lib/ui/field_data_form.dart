import 'package:fast_form_filler/domain/fields_controller.dart';
import 'package:flutter/material.dart';
import 'package:fast_form_filler/domain/field.dart';
import 'package:get/get.dart';

class FieldDataForm extends StatelessWidget {
  final Field field;

  const FieldDataForm({Key? key, required this.field}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataController = TextEditingController(text: field.data);
    final formKey = GlobalKey<FormState>();

    return Card(
      elevation: 3.0,
      child: ListTile(
        title: Form(
          key: formKey,
          child: TextFormField(
            controller: dataController,
            decoration: InputDecoration(
              labelText: field.title,
              suffix: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => Get.find<FieldsController>().openEditor(field),
              ),
            ),
            validator: field.validateField,
            onEditingComplete: () {
              if (formKey.currentState!.validate()) {
                final fieldsController = Get.find<FieldsController>();
                final updatedField = field.copyWith(
                  data: dataController.text,
                );
                fieldsController.updateField(updatedField);
                fieldsController.closeEditor();
              }
            },
          ),
        ),
      ),
    );
  }
}
