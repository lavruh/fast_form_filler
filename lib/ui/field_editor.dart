import 'package:fast_form_filler/domain/fields_controller.dart';
import 'package:fast_form_filler/domain/show_port.dart';
import 'package:flutter/material.dart';
import 'package:fast_form_filler/domain/field.dart';
import 'package:get/get.dart';

class FieldEditor extends StatefulWidget {
  final Field field;

  const FieldEditor({Key? key, required this.field}) : super(key: key);

  @override
  FieldEditorState createState() {
    return FieldEditorState();
  }
}

class FieldEditorState extends State<FieldEditor> {
  late TextEditingController _titleController;
  late FieldType _selectedFieldType;
  List<ShowPort> showPorts = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.field.title);
    _selectedFieldType = widget.field.fieldType;
    showPorts = widget.field.showPorts;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<FieldType>(
            value: _selectedFieldType,
            onChanged: (FieldType? newValue) {
              setState(() {
                _selectedFieldType = newValue!;
              });
            },
            items: FieldType.values.map((FieldType fieldType) {
              return DropdownMenuItem<FieldType>(
                value: fieldType,
                child: Text(fieldType.toString().split('.').last),
              );
            }).toList(),
            decoration: const InputDecoration(labelText: 'Field Type'),
          ),
          const SizedBox(height: 20),
          TextButton(onPressed: () {
            showPorts.add(ShowPort(page: 0, position: Rect.fromLTWH(150, 150, 100, 100)));
          }, child: const Text("Add show port")),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Update the field with the edited values
              final fieldsController = Get.find<FieldsController>();
              Field updatedField = widget.field.copyWith(
                title: _titleController.text,
                fieldType: _selectedFieldType,
              );
              fieldsController.updateField(updatedField);

              // Close the editor
              fieldsController.closeEditor();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
