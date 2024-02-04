import 'package:fast_form_filler/domain/file_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GenerationSettingsDialog extends StatefulWidget {
  const GenerationSettingsDialog({super.key});

  @override
  GenerationSettingsDialogState createState() {
    return GenerationSettingsDialogState();
  }
}

class GenerationSettingsDialogState extends State<GenerationSettingsDialog> {
  final TextEditingController _selectPagesController =
      TextEditingController(text: "1");
  final TextEditingController _iterationsController =
      TextEditingController(text: "1");
  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: key,
      child: AlertDialog(
        title: const Text('Generation Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _selectPagesController,
              validator: validatorListInt,
              decoration: const InputDecoration(
                  labelText: 'Pages to duplicate (1,2,3...)'),
              onEditingComplete: () => key.currentState!.validate(),
            ),
            TextFormField(
              controller: _iterationsController,
              keyboardType: TextInputType.number,
              validator: validator,
              decoration:
                  const InputDecoration(labelText: 'Number of Iterations'),
              onEditingComplete: () => key.currentState!.validate(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (key.currentState!.validate() &&
                  _iterationsController.text.isNotEmpty) {
                int iterations = int.parse(_iterationsController.text);
                final selectedPagesList =
                    listIntParser(_selectPagesController.text);
                final fileController = Get.find<FileController>();
                try {
                  fileController.createFileFromIteratingFields(
                    numberOfIterations: iterations,
                    pagesToIterate: selectedPagesList,
                  );
                } on Exception catch (e) {
                  Get.snackbar("Error", e.toString());
                  return;
                }

                Navigator.pop(context);
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String? validator(String? val) {
    if (val == null) return 'Incorrect value';
    final i = int.tryParse(val);
    if (i == null) return 'Should be integer';
    if (i <= 0) return 'Should be bigger then 0';
    return null;
  }

  String? validatorListInt(String? value) {
    if (value == null) return "Incorrect value";
    try {
      final list = listIntParser(value);
      if (list.isEmpty) return "Should not be empty";
    } on Exception catch (_) {
      return "Incorrect value";
    }

    return null;
  }

  List<int> listIntParser(String val) {
    return val.split(",").map((i) => int.parse(i)).toList();
  }
}

Future<int?> showGenerationSettingsDialog(BuildContext context) async {
  return await showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      return const GenerationSettingsDialog();
    },
  );
}
