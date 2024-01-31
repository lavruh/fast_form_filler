import 'package:fast_form_filler/domain/fields_controller.dart';
import 'package:flutter/material.dart';
import 'package:fast_form_filler/domain/show_port.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class ShowPortEditor extends StatefulWidget {
  final ShowPort showPort;

  const ShowPortEditor({Key? key, required this.showPort}) : super(key: key);

  @override
  State<ShowPortEditor> createState() => _ShowPortEditorState();
}

class _ShowPortEditorState extends State<ShowPortEditor> {
  PdfFontFamily font = PdfFontFamily.timesRoman;
  TextEditingController pageController = TextEditingController();
  TextEditingController leftController = TextEditingController();
  TextEditingController topController = TextEditingController();
  TextEditingController fontSizeController = TextEditingController();

  @override
  void initState() {
    font = widget.showPort.font;
    pageController.text = widget.showPort.page.toString();
    leftController.text = widget.showPort.position.left.toString();
    topController.text = widget.showPort.position.top.toString();
    fontSizeController.text = widget.showPort.fontSize.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<FieldsController>(builder: (state) {
      return Card(
        color: state.selectedShowPort == widget.showPort
            ? Colors.yellow
            : Colors.white,
        elevation: 4.0,
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Flex(
                direction: Axis.horizontal,
                children: [
                  Flexible(
                      flex: 2,
                      child: TextButton(
                          onPressed: () {
                            state.selectShowPort(widget.showPort);
                          },
                          child: Text(
                            widget.showPort.id,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ))),
                  Flexible(
                    flex: 3,
                    child: TextField(
                      controller: pageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Page"),
                    ),
                  ),
                  Flexible(
                    child: IconButton(
                      onPressed: () {
                        state.selectShowPort(widget.showPort);
                        ShowPort updatedShowPort = widget.showPort.copyWith(
                            page: int.parse(pageController.text),
                            position: Rect.fromLTWH(
                                double.parse(leftController.text),
                                double.parse(topController.text),
                                widget.showPort.position.width,
                                widget.showPort.position.height),
                            fontSize: int.parse(fontSizeController.text),
                            font: font);
                        state.updateSelectedShowPort(updatedShowPort);
                      },
                      icon: const Icon(Icons.save),
                    ),
                  ),
                  Flexible(
                    child: IconButton(
                      onPressed: () => state.deleteShowPort(widget.showPort),
                      icon: const Icon(Icons.delete),
                    ),
                  )
                ],
              ),
              _buildTextFieldRow('Top', topController, 'Left', leftController),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: fontSizeController,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: "Font size"),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<PdfFontFamily>(
                        value: font, // Default value, replace with actual value
                        onChanged: (PdfFontFamily? newValue) {
                          font = newValue ?? font;
                          setState(() {});
                        },
                        items: PdfFontFamily.values.map((PdfFontFamily font) {
                          return DropdownMenuItem<PdfFontFamily>(
                            value: font,
                            child: Text(font.toString().split('.').last),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTextFieldRow(String label1, TextEditingController controller1,
      String label2, TextEditingController controller2) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller1,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: label1),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller2,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: label2),
            ),
          ),
        ),
      ],
    );
  }
}
