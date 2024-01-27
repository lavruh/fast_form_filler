import 'dart:io';

import 'package:fast_form_filler/domain/fields_controller.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfPreviewWidget extends StatefulWidget {
  const PdfPreviewWidget({
    super.key,
    required this.doc,
    required this.state,
  });
  final File doc;
  final FieldsController state;

  @override
  State<PdfPreviewWidget> createState() => _PdfPreviewWidgetState();
}

class _PdfPreviewWidgetState extends State<PdfPreviewWidget> {
  late final state;

  @override
  void initState() {
    state = widget.state;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      state.jumpToLastOpenedPage();
    });
    return SfPdfViewer.file(widget.doc,
        controller: state.pdfController,
        interactionMode: PdfInteractionMode.pan,
        enableTextSelection: false,
        canShowScrollHead: false,
        canShowScrollStatus: false,
        onPageChanged: (_) => state.updatePageInformation(),
        onTap: (details) {
          final port = state.selectedShowPort;
          if (port != null) {
            final pos = details.pagePosition;
            state.updateSelectedShowPort(port.copyWith(
                page: details.pageNumber,
                position: Rect.fromLTWH(pos.dx, pos.dy, port.position.width,
                    port.position.height)));
          }
        });
  }
}
