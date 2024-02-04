import 'package:fast_form_filler/domain/fields_controller.dart';
import 'package:fast_form_filler/domain/file_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fast_form_filler/domain/field.dart';
import 'package:get/get.dart';

void main() {
  group('FieldsController', () {
    test('saveFieldsDataAsJson should encode fields to JSON', () {
      // Arrange
      Get.put<FileController>(FileController());
      final fieldsController = Get.put<FieldsController>(FieldsController());
      fieldsController.fields.add(
        const Field(
            id: '1',
            title: 'Field 1',
            data: 'Data 1',
            showPorts: [],
            fieldType: FieldType.same,
            dataType: FieldDataType.string),
      );

      // Act
      final jsonString = fieldsController.saveFieldsDataAsJson();

      // Assert
      expect(jsonString, isNotNull);
      expect(jsonString, isNotEmpty);
      // Add more specific assertions based on the expected JSON structure
    });

    test('loadFieldsFromJson should decode JSON to fields', () {
      // Arrange
      Get.put<FileController>(FileController());
      final fieldsController = Get.put<FieldsController>(FieldsController());
      fieldsController.fields.add(
        const Field(
            id: '1',
            title: 'Field 1',
            data: 'Data 1',
            showPorts: [],
            fieldType: FieldType.same,
            dataType: FieldDataType.number),
      );

      // Act
      final jsonString = fieldsController.saveFieldsDataAsJson();

      // Act
      fieldsController.loadFieldsFromJson(json: jsonString);

      // Assert
      expect(fieldsController.fields, isNotEmpty);
      expect(fieldsController.fields.length, equals(1));
      // Add more specific assertions based on the expected field values
    });
  });
}
