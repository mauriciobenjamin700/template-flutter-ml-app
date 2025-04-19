import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import '../core/constants.dart';

class PredictService {
  late Interpreter interpreter;

  void initPredict() async {
    debugPrint("tentando iniciar o modelo");
    interpreter = await Interpreter.fromAsset(Constants.model);
    debugPrint("modelo carregado com sucesso");
  }

  Uint8List imageToByteListFloat32(
    Uint8List imageBytes,
    int height,
    int width,
  ) {
    debugPrint("entrei na função imageToByre...");
    var convertedBytes = Float32List(1 * height * width * 3);
    // var buffer = Float32List.view(convertedBytes.buffer);
    List<double> buffer = List.filled(
      (imageBytes.length ~/ 4) * 3,
      0.0,
    ); //-------------------------
    int pixelIndex = 0;

    debugPrint("antes do for da função imageToByre...");

    for (int i = 0; i <= imageBytes.length - 4; i += 4) {
      var r = imageBytes[i] / 255.0;
      var g = imageBytes[i + 1] / 255.0;
      var b = imageBytes[i + 2] / 255.0;

      buffer[pixelIndex++] = r;
      buffer[pixelIndex++] = g;
      buffer[pixelIndex++] = b;
    }
    debugPrint("depois do for da função imageToByre...");

    return convertedBytes.buffer.asUint8List();
  }

  Uint8List preProcessament(File file) {
    debugPrint("tentando processar o modelo");
    var imageBytes = file.readAsBytesSync();
    debugPrint("modelo processado");

    final result = imageToByteListFloat32(imageBytes, 640, 640);
    debugPrint("Resultado do pré-processamento: ${result.toString()}");

    return result;
  }

  Future<int> runModel(Uint8List imageTensor) async {
    debugPrint("tentando rodar o modelo");
    debugPrint("imagem tensor: ${imageTensor.toString()}");
    debugPrint("imagem tensor: ${imageTensor.length}");
    debugPrint("imagem tensor: ${imageTensor[0]}");
    debugPrint("imagem tensor: ${imageTensor[1]}");
    debugPrint("imagem tensor: ${imageTensor[2]}");

    var inputShape = interpreter.getInputTensor(0).shape;
    debugPrint("Input shape esperado: $inputShape");

    var outputShape = interpreter.getOutputTensor(0).shape;
    debugPrint("Output shape esperado: $outputShape");

    try {
      final output = List<double>.filled(2, 0).reshape([1, 2]);
      debugPrint("parte do modelo rodou wiii");
      interpreter.run(imageTensor, output);
      debugPrint("modelo rodou wiii");

      debugPrint("output: $output");

      final result = output[0][0] > 0.5 ? 1 : 0;

      debugPrint("Resultado da predição ${result.toString()}");

      return result;
    } catch (e) {
      debugPrint("Erro ao rodar o modelo: $e");
      throw Exception("Erro ao rodar o modelo");
    }
  }

  Future<int> predict(File file) async {
    debugPrint("tentando predicar o modelo");

    final imageTensor = preProcessament(file);
    debugPrint("o modelo predicado");

    return await runModel(imageTensor);
  }
}
