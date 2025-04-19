import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

import '../core/constants.dart';
import '../schemas/result.dart';

class PredictService {
  late Interpreter interpreter;
  bool initialized = false;

  Future<void> initPredict() async {
    interpreter = await Interpreter.fromAsset(Constants.model);
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
      var r = imagePixels[i] / 255.0;
      var g = imagePixels[i + 1] / 255.0;
      var b = imagePixels[i + 2] / 255.0;

      convertedBytes[pixelIndex++] = r;
      convertedBytes[pixelIndex++] = g;
      convertedBytes[pixelIndex++] = b;
    }

    return convertedBytes.buffer.asUint8List();
  }

  Uint8List preProcessament(File file) {
    debugPrint("tentando processar a imagem");
    final originalImage = img.decodeImage(file.readAsBytesSync())!;
    final resizedImage = img.copyResize(originalImage, width: 640, height: 640);
    final imageBytes = resizedImage.getBytes();

    final result = imageToByteListFloat32(imageBytes, 640, 640);
    debugPrint("Resultado do pré-processamento: ${result.length}");

    return result;
  }

  PredictionResult processOutput(List<List<List<double>>> output) {
    double maxScore = 0;
    int bestClassIndex = -1;

    for (int i = 0; i < output[0].length; i++) {
      for (int j = 0; j < output[0][i].length; j++) {
        if (output[0][i][j] > maxScore) {
          maxScore = output[0][i][j];
          bestClassIndex = i;
        }
      }
    }

    debugPrint(
      "Classe com maior probabilidade: $bestClassIndex, Pontuação: $maxScore",
    );
    return PredictionResult(classIndex: bestClassIndex, score: maxScore);
  }

  Future<PredictionResult> runModel(Uint8List imageTensor) async {
    debugPrint("tentando rodar o modelo");
    final inputShape = interpreter.getInputTensor(0).shape;
    debugPrint("Input shape esperado: $inputShape");

    final outputShape = interpreter.getOutputTensor(0).shape;
    debugPrint("Output shape esperado: $outputShape");

    final input = imageTensor.buffer.asFloat32List().reshape(inputShape);
    final output = List<double>.filled(
      outputShape.reduce((a, b) => a * b),
      0,
    ).reshape(outputShape);

    try {
      interpreter.run(input, output);
      debugPrint("output: $output");

      return processOutput(output.cast<List<List<double>>>());
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
    debugPrint("resultado do predict: $result");

    return result;
  }
}
