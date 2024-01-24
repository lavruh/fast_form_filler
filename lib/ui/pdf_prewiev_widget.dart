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
    return GetBuilder<FieldsController>(builder: (state) {
      List<Widget> viewPorts = [];
      final field = state.fieldToEdit;
      if (field != null) {
        for (final port in field.showPorts) {
          if (state.openedPage == port.page) {
            final widget = ShowPortWidget(port: port, label: field.title);
            viewPorts.add(widget);
          }
        }
      }

      return Stack(
        children: [
          SfPdfViewer.file(
            doc,
            controller: state.pdfController,
            pageLayoutMode: PdfPageLayoutMode.single,
            interactionMode: PdfInteractionMode.pan,
            enableDoubleTapZooming: false,
            enableTextSelection: false,
            canShowScrollHead: false,
            canShowScrollStatus: false,
            onPageChanged: (_) {
              state.update();
            },
            onZoomLevelChanged: (_) {
              state.pdfController.zoomLevel = 0;
            },
            onTap: (details) {
              final port = state.selectedShowPort;
              if (port != null) {
                final pos = details.position;
                state.updateSelectedShowPort(port.copyWith(
                    page: details.pageNumber,
                    position: Rect.fromLTWH(pos.dx, pos.dy, port.position.width,
                        port.position.height)));
              }
            },
          ),
          ...viewPorts,
        ],
      );
    });
  }
}
