import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

import '../core/constants.dart';
import '../schemas/result.dart';

class ClassifyService {
  late Interpreter interpreter;
  late List<String> labels;
  bool initialized = false;

  Future<void> initPredict() async {
    interpreter = await Interpreter.fromAsset(Constants.model);
    final labelTxt = await rootBundle.loadString('assets/classify/labels.txt');
    labels = labelTxt.split('\n');
    initialized = true;
  }

  Uint8List imageToByteListFloat32(
    Uint8List imagePixels,
    int height,
    int width,
  ) {
    final convertedBytes = Float32List(1 * height * width * 3);
    int pixelIndex = 0;

    for (int i = 0; i <= imagePixels.length - 4; i += 4) {
      final r = (imagePixels[i] - 127.5) / 127.5;
      final g = (imagePixels[i + 1] - 127.5) / 127.5;
      final b = (imagePixels[i + 2] - 127.5) / 127.5;

      convertedBytes[pixelIndex++] = r;
      convertedBytes[pixelIndex++] = g;
      convertedBytes[pixelIndex++] = b;
    }

    return convertedBytes.buffer.asUint8List();
  }

  Uint8List preProcessament(File file) {
    final originalImage = img.decodeImage(file.readAsBytesSync())!;
    final resizedImage = img.copyResize(originalImage, width: 224, height: 224);
    final imageBytes = resizedImage.getBytes();
    final result = imageToByteListFloat32(imageBytes, 224, 224);
    return result;
  }

  List<double> softmax(List<double> logits) {
    final maxLogit = logits.reduce(max);
    final expScores = logits.map((x) => exp(x - maxLogit)).toList();
    final sumExp = expScores.reduce((a, b) => a + b);
    return expScores.map((x) => x / sumExp).toList();
  }

  PredictionResult processOutput(List<double> output) {
    double maxScore = 0;
    int bestClassIndex = -1;

    for (int i = 0; i < output.length; i++) {
      if (output[i] > maxScore) {
        maxScore = output[i];
        bestClassIndex = i;
      }
    }

    final label = labels[bestClassIndex];
    debugPrint("Classe: $label ($bestClassIndex), Score: $maxScore");

    return PredictionResult(
      classIndex: bestClassIndex,
      score: maxScore,
      label: label,
    );
  }

  Future<PredictionResult> runModel(Uint8List imageTensor) async {

    final inputShape = interpreter.getInputTensor(0).shape;
    final outputShape = interpreter.getOutputTensor(0).shape;
    debugPrint("Input shape esperado: $inputShape");
    debugPrint("Output shape esperado: $outputShape");

    final input = imageTensor.buffer.asFloat32List().reshape(inputShape);

    final output = List.generate(
      outputShape[0],
      (_) => List<double>.filled(outputShape[1], 0),
    );

    try {
      interpreter.run(input, output);
      //debugPrint("Output: $output");
      debugPrint("Output Length: ${output[0].length}");
      final probs = softmax(output[0]);
      return processOutput(probs);
    } catch (e) {
      debugPrint("Erro ao rodar o modelo: $e");
      throw Exception("Erro ao rodar o modelo");
    }
  }

  Future<PredictionResult> predict(File file) async {
    debugPrint("Predict Iniciado");

    if (!initialized) {
      debugPrint("Inicializando o interpretador...");
      await initPredict();
    }

    final imageTensor = preProcessament(file);
    debugPrint("Input Processado");

    final result = await runModel(imageTensor);
    debugPrint("Resultado do predict: $result");

    return result;
  }
}
