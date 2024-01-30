import 'package:fast_form_filler/domain/fields_controller.dart';
import 'package:fast_form_filler/domain/file_controller.dart';
import 'package:fast_form_filler/ui/fields_menu.dart';
import 'package:fast_form_filler/ui/pdf_prewiev_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<FileController>(
        builder: (state) {
          final doc = state.file;
          if (doc == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    child: const Text('Open PDF'),
                    onPressed: () => state.openPdfFile(),
                  ),
                  TextButton(
                      onPressed: () => state.openTemplate(),
                      child: const Text("Open saved form"))
                ],
              ),
            );
          }
          return Flex(
            direction: Axis.horizontal,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                  flex: 3,
                  child: GetBuilder<FieldsController>(
                    builder: (state) {
                      return PdfPreviewWidget(
                        doc: doc,
                        state: state,
                      );
                    },
                  )),
              const Flexible(flex: 1, child: FieldsMenu()),
            ],
          );
        },
      ),
    );
  }
}
