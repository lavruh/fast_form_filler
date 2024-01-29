import 'package:fast_form_filler/domain/fields_controller.dart';
import 'package:flutter/material.dart';
import 'package:fast_form_filler/domain/show_port.dart';
import 'package:get/get.dart';

class ShowPortEditor extends StatelessWidget {
  final ShowPort showPort;

  const ShowPortEditor({Key? key, required this.showPort}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController pageController =
        TextEditingController(text: showPort.page.toString());
    TextEditingController leftController =
        TextEditingController(text: showPort.position.left.toString());
    TextEditingController topController =
        TextEditingController(text: showPort.position.top.toString());

    return GetX<FieldsController>(builder: (state) {
      return Card(
        color:
            state.selectedShowPort == showPort ? Colors.yellow : Colors.white,
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
                            state.selectShowPort(showPort);
                          },
                          child: Text(
                            showPort.id,
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
                        state.selectShowPort(showPort);
                        ShowPort updatedShowPort = showPort.copyWith(
                            page: int.parse(pageController.text),
                            position: Rect.fromLTWH(
                                double.parse(leftController.text),
                                double.parse(topController.text),
                                showPort.position.width,
                                showPort.position.height));
                        state.updateSelectedShowPort(updatedShowPort);
                      },
                      icon: const Icon(Icons.save),
                    ),
                  ),
                  Flexible(
                    child: IconButton(
                      onPressed: () => state.deleteShowPort(showPort),
                      icon: const Icon(Icons.delete),
                    ),
                  )
                ],
              ),
              _buildTextFieldRow('Top', topController, 'Left', leftController),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTextFieldRow(String label1, TextEditingController controller1,
      String label2, TextEditingController? controller2) {
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
