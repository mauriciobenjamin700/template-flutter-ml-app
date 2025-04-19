import 'package:flutter/services.dart' show rootBundle;

String formatToPercentage(double value) {
  return "${(value * 100).toStringAsFixed(2).replaceAll('.', ',')}%";
}
String formatToDecimal(double value) {
  return value.toStringAsFixed(2).replaceAll('.', ',');
}

Future<String> getLabelById(int id) async {
  try {
    // Carrega o conteúdo do arquivo labels.txt
    final labelsData = await rootBundle.loadString('assets/labels.txt');
    // Divide o conteúdo em linhas
    final labels = labelsData.split('\n').where((label) => label.isNotEmpty).toList();

    // Verifica se o ID está dentro do intervalo válido
    if (id >= 0 && id < labels.length) {
      return labels[id]; // Retorna a string correspondente ao ID
    } else {
      throw Exception('ID fora do intervalo válido.');
    }
  } catch (e) {
    throw Exception('Erro ao carregar o arquivo de labels: $e');
  }
}