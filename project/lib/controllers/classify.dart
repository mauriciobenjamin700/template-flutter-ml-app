import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/schemas/result.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import '../core/constants.dart';
import '../services/classify.dart';

class ClassifyController extends ChangeNotifier {
  String? imagePath;
  final imagePicker = ImagePicker();
  late Interpreter interpreter;
  PredictionResult valuePredict = Constants.value;
  bool isError = false;
  final controller = ClassifyService();

  void initController() async {
    controller.initPredict();
    notifyListeners();
  }

  void cleanResult() {
    imagePath = null;
    isError = false;
    valuePredict = Constants.value;
    notifyListeners();
  }

  Future<void> predict(File file) async {
    try {
      controller.initPredict();
      valuePredict = await controller.predict(file);

      debugPrint("Valor do resultado: $valuePredict");

    } catch (e) {
      valuePredict = Constants.value;
      isError = true;
    }
  }
}
