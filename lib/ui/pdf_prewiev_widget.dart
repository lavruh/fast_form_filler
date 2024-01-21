import 'dart:io';

import 'package:fast_form_filler/domain/fields_controller.dart';
import 'package:fast_form_filler/ui/showport_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfPreviewWidget extends StatelessWidget {
  const PdfPreviewWidget({
    super.key,
    required this.doc,
  });
  final File doc;

  @override
  Widget build(BuildContext context) {
    return GetX<FieldsController>(builder: (state) {
      List<Widget> viewPorts = [];
      for (final field in state.fields) {
        for (final port in field.showPorts) {
          final widget = Draggable(
            onDragEnd: (details){
              // state.updateField(val);
            },
              feedback: ShowPortWidget(port: port),
              child: ShowPortWidget(port: port));

          viewPorts.add(widget);
        }
      }

      return Stack(
        children: [
          SfPdfViewer.file(
            doc,
            pageLayoutMode: PdfPageLayoutMode.single,
          ),
          ...viewPorts,
        ],
      );
    });
  }
}
