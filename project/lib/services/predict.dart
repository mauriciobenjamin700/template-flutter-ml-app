import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
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
    Uint8List imageBytes,
    int height,
    int width,
  ) {

    var convertedBytes = Float32List(1 * height * width * 3);
    List<double> buffer = List.filled(
      (imageBytes.length ~/ 4) * 3,
      0.0,
    ); 
    int pixelIndex = 0;

    for (int i = 0; i <= imageBytes.length - 4; i += 4) {
      var r = imageBytes[i] / 255.0;
      var g = imageBytes[i + 1] / 255.0;
      var b = imageBytes[i + 2] / 255.0;

      buffer[pixelIndex++] = r;
      buffer[pixelIndex++] = g;
      buffer[pixelIndex++] = b;
    }


    return convertedBytes.buffer.asUint8List();
  }

  Uint8List preProcessament(File file) {
    debugPrint("tentando processar a imagem");
    var imageBytes = file.readAsBytesSync();
    debugPrint("image processada");

    final result = imageToByteListFloat32(imageBytes, 640, 640);
    debugPrint("Resultado do pré-processamento: ${result.toString()}");

    return result;
  }

  PredictionResult processOutput(List<List<List<double>>> output) {
      // Exemplo: Pegue o índice com maior probabilidade
      // Ajuste esta lógica com base no que o modelo retorna
      double maxScore = 0;
      int bestClassIndex = -1;

      for (int i = 0; i < output[0].length; i++) {
        for (int j = 0; j < output[0][i].length; j++) {
          if (output[0][i][j] > maxScore) {
            maxScore = output[0][i][j];
            bestClassIndex = i; // Ou ajuste conforme necessário
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
    var inputShape = interpreter.getInputTensor(0).shape;
    debugPrint("Input shape esperado: $inputShape");

    var outputShape = interpreter.getOutputTensor(0).shape;
    debugPrint("Output shape esperado: $outputShape");

    try {
      // final output = List<double>.filled(2, 0).reshape([1, 2]); // em caso de classificação binaria
      // Crie o buffer de saída com a forma correta
      final output = List<double>.filled(
        outputShape.reduce(
          (a, b) => a * b,
        ), // Calcula o tamanho total do buffer
        0,
      ).reshape(outputShape);
      // debugPrint("parte do modelo rodou wiii");
      interpreter.run(imageTensor, output);
      // debugPrint("modelo rodou wiii");

      debugPrint("output: $output");

      // Processar o resultado (exemplo: pegar o índice com maior probabilidade)
      final result = processOutput(output.cast<List<List<double>>>());

      // final result = output[0][0] > 0.5 ? 1 : 0; // use em caso de classificação binária

      return result;
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
