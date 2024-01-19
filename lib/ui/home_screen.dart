import 'package:fast_form_filler/domain/file_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<FileController>(
      builder: (state) {
        final doc = state.file;
        if (doc == null) {
          return Center(
            child: TextButton(
              child: const Text('Open file'),
              onPressed: () => state.openPdfFile(),
            ),
          );
        }
        return SfPdfViewer.file(doc);
      },
    );
  }
}
