import 'package:fast_form_filler/domain/fields_controller.dart';
import 'package:fast_form_filler/ui/field_editor.dart';
import 'package:fast_form_filler/ui/fields_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FieldsMenu extends StatelessWidget {
  const FieldsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<FieldsController>(
      builder: (state) {
        final field = state.fieldToEdit;
        if (field != null) {
          return FieldEditor(field: field);
        }
        return const FieldsData();
      },
    );
  }
}
