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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = Get.find<FieldsController>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: TextEditingController(text: widget.field.title),
            decoration: const InputDecoration(labelText: 'Title'),
            onSubmitted: (val) =>
                state.openEditor(widget.field.copyWith(title: val)),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<FieldType>(
            value: widget.field.fieldType,
            onChanged: (FieldType? newValue) =>
                state.openEditor(widget.field.copyWith(fieldType: newValue)),
            items: FieldType.values.map((FieldType fieldType) {
              return DropdownMenuItem<FieldType>(
                value: fieldType,
                child: Text(fieldType.toString().split('.').last),
              );
            }).toList(),
            decoration: const InputDecoration(labelText: 'Field Type'),
          ),
          const SizedBox(height: 20),
          TextButton(
              onPressed: () {
                final showPortsList = widget.field.showPorts;
                state.openEditor(widget.field
                    .copyWith(showPorts: [...showPortsList, ShowPort.empty()]));
              },
              child: const Text("Add show port")),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => state.saveState(),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
