import 'package:fast_form_filler/domain/fields_controller.dart';
import 'package:fast_form_filler/domain/show_port.dart';
import 'package:fast_form_filler/ui/showport_editor.dart';
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
      padding: const EdgeInsets.all(8.0),
      child: Flex(direction: Axis.vertical, children: [
        Flexible(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flex(
                direction: Axis.horizontal,
                children: [
                  Flexible(
                    flex: 5,
                    child: TextField(
                      controller:
                          TextEditingController(text: widget.field.title),
                      decoration: const InputDecoration(labelText: 'Title'),
                      onSubmitted: (val) =>
                          state.openEditor(widget.field.copyWith(title: val)),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: IconButton(
                        onPressed: () => state.saveState(),
                        icon: const Icon(Icons.save)),
                  ),
                ],
              ),
              DropdownButtonFormField<FieldType>(
                value: widget.field.fieldType,
                onChanged: (FieldType? newValue) => state
                    .openEditor(widget.field.copyWith(fieldType: newValue)),
                items: FieldType.values.map((FieldType fieldType) {
                  return DropdownMenuItem<FieldType>(
                    value: fieldType,
                    child: Text(fieldType.toString().split('.').last),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Field Type'),
              ),
              TextButton(
                  onPressed: () {
                    final showPortsList = widget.field.showPorts;
                    final page = state.openedPage;
                    state.openEditor(widget.field.copyWith(showPorts: [
                      ...showPortsList,
                      ShowPort.empty().copyWith(page: page)
                    ]));
                  },
                  child: const Text("Add show port")),
            ],
          ),
        ),
        Flexible(
          flex: 3,
          child: SingleChildScrollView(
            child: Column(
              children: widget.field.showPorts
                  .map((e) => ShowPortEditor(showPort: e))
                  .toList(),
            ),
          ),
        ),
      ]),
    );
  }
}
