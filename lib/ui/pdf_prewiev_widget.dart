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
      final field = state.fieldToEdit;
      if (field != null) {
        for (final port in field.showPorts) {
          final widget = ShowPortWidget(port: port, label: field.title);
          viewPorts.add(widget);
        }
      }

      return Stack(
        children: [
          SfPdfViewer.file(
            doc,
            pageLayoutMode: PdfPageLayoutMode.single,
            onTap: (details) {
              final port = state.selectedShowPort;
              if (port != null) {
                final pos = details.position;
                state.updateSelectedShowPort(port.copyWith(
                    page: details.pageNumber,
                    position: Rect.fromLTWH(pos.dx, pos.dy, 100, 50)));
              }
            },
          ),
          ...viewPorts,
        ],
      );
    });
  }
}
