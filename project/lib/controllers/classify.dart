import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import '../core/constants.dart';
import '../services/predict.dart';

class ClassifyController extends ChangeNotifier {
  String? imagePath;
  final imagePicker = ImagePicker();
  late Interpreter interpreter;
  int valuePredict = Constants.value;
  bool isError = false;
  final controller = PredictService();
  String resultado = '';

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

      resultado = formatOutput(valuePredict);
    } catch (e) {
      valuePredict = Constants.value;
      isError = true;
    }
  }

  String formatOutput(int value) {
    debugPrint("Valor do resultado: $value");
    if (value == 1) {
      return 'Resultado ${double.parse(value.toStringAsFixed(1))}: Vermifuga detectada';
    } else {
      return 'Resultado ${double.parse(value.toStringAsFixed(1))}: Vermifuga não detectada';
    }
  }
}
