import 'package:fast_form_filler/domain/fields_controller.dart';
import 'package:fast_form_filler/domain/list_field.dart';
import 'package:flutter/material.dart';
import 'package:fast_form_filler/domain/field.dart';
import 'package:get/get.dart';

class FieldDataForm extends StatelessWidget {
  final Field field;

  const FieldDataForm({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Card(
      elevation: 3.0,
      child: ListTile(
        title: Form(
          key: formKey,
          child: field.runtimeType != ListField
              ? _input(formKey)
              : _valuesDropdown(),
        ),
      ),
    );
  }

  Widget _valuesDropdown() {
    final values = (field as ListField).values;
    final initValue = values.contains(field.data) ? field.data : null;
    return Row(
      children: [
        Flexible(
          child: DropdownButtonFormField<String>(
            value: initValue,
            onChanged: (String? val) {
              if (val != null) _updateField(val);
            },
            items: values.map((String e) {
              return DropdownMenuItem<String>(value: e, child: Text(e));
            }).toList(),
            decoration: InputDecoration(labelText: field.title),
          ),
        ),
        _editFieldButton(),
      ],
    );
  }

  Widget _input(GlobalKey<FormState> formKey) {
    final dataController = TextEditingController(text: field.data);
    return TextFormField(
      controller: dataController,
      decoration:
          InputDecoration(labelText: field.title, suffix: _editFieldButton()),
      validator: field.validateField,
      onEditingComplete: () {
        if (formKey.currentState!.validate()) {
          _updateField(dataController.text);
        }
      },
    );
  }

  Widget _editFieldButton() {
    return IconButton(
      icon: const Icon(Icons.more_vert),
      onPressed: () => Get.find<FieldsController>().openEditor(field),
    );
  }

  _updateField(String val) {
    final fieldsController = Get.find<FieldsController>();
    final updatedField = field.copyWith(
      data: val,
    );
    fieldsController.updateField(updatedField);
    fieldsController.closeEditor();
  }
}
