import 'package:fast_form_filler/domain/fields_controller.dart';
import 'package:fast_form_filler/domain/show_port.dart';
import 'package:fast_form_filler/domain/list_field.dart';
import 'package:fast_form_filler/ui/showport_editor.dart';
import 'package:flutter/material.dart';
import 'package:fast_form_filler/domain/field.dart';
import 'package:get/get.dart';

class FieldEditor extends StatefulWidget {
  final Field field;

  const FieldEditor({super.key, required this.field});

  @override
  FieldEditorState createState() {
    return FieldEditorState();
  }
}

class FieldEditorState extends State<FieldEditor> {
  final state = Get.find<FieldsController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
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
                    Flexible(flex: 5, child: _title()),
                    ..._menu(),
                  ],
                ),
                _fieldType(),
                _fieldDataType(),
                _stringValuesEditor(),
                _addShowPortButton(),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: widget.field.showPorts
                    .map((e) => ShowPortEditor(
                          showPort: e,
                          key: Key(e.hashCode.toString()),
                        ))
                    .toList(),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _stringValuesEditor() {
    final field = widget.field;
    if (field.runtimeType == ListField) {
      final text = (field as ListField).values.join(",");
      return TextField(
        controller: TextEditingController(text: text),
        decoration: const InputDecoration(labelText: 'List values', helperText: "Comma separated values 1,2,3... etc."),
        onSubmitted: (val) {
          final values = val.split(",");
          state.openEditor(field.copyWith(values: values));
        },
      );
    }
    return Container();
  }

  Widget _title() {
    return TextField(
      controller: TextEditingController(text: widget.field.title),
      decoration: const InputDecoration(labelText: 'Title'),
      onSubmitted: (val) => state.openEditor(widget.field.copyWith(title: val)),
    );
  }

  List<Widget> _menu() {
    return [
      Flexible(
        flex: 1,
        child: IconButton(
            onPressed: () => state.closeEditor(),
            icon: const Icon(Icons.arrow_back)),
      ),
      Flexible(
        flex: 1,
        child: IconButton(
            onPressed: () => state.saveState(), icon: const Icon(Icons.save)),
      ),
      Flexible(
        flex: 1,
        child: IconButton(
            onPressed: () => state.deleteField(widget.field),
            icon: const Icon(Icons.delete)),
      ),
    ];
  }

  Widget _fieldType() {
    return DropdownButtonFormField<FieldType>(
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
    );
  }

  Widget _fieldDataType() {
    return DropdownButtonFormField<FieldDataType>(
      value: widget.field.dataType,
      onChanged: (FieldDataType? newValue) =>
          state.openEditor(widget.field.copyWith(dataType: newValue)),
      items: FieldDataType.values.map((FieldDataType dt) {
        return DropdownMenuItem<FieldDataType>(
          value: dt,
          child: Text(dt.toString().split('.').last),
        );
      }).toList(),
      decoration: const InputDecoration(labelText: 'Field Data Type'),
    );
  }

  Widget _addShowPortButton() {
    return TextButton(
        onPressed: () {
          final showPortsList = widget.field.showPorts;
          final page = state.openedPage;
          state.openEditor(widget.field.copyWith(showPorts: [
            ...showPortsList,
            ShowPort.empty(id: showPortsList.length.toString())
                .copyWith(page: page)
          ]));
        },
        child: const Text("Add show port"));
  }
}
