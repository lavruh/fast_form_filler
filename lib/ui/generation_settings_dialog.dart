import 'package:flutter/material.dart';

class GenerationSettingsDialog extends StatefulWidget {
  const GenerationSettingsDialog({super.key});

  @override
  GenerationSettingsDialogState createState() {
    return GenerationSettingsDialogState();
  }
}

class GenerationSettingsDialogState extends State<GenerationSettingsDialog> {
  final TextEditingController _iterationsController = TextEditingController();
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
              controller: _iterationsController,
              keyboardType: TextInputType.number,
              validator: validator,
              decoration:
                  const InputDecoration(labelText: 'Number of Iterations'),
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
                Navigator.pop(context, iterations);
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
}

Future<int?> showGenerationSettingsDialog(BuildContext context) async {
  return await showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      return const GenerationSettingsDialog();
    },
  );
}
