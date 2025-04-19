import 'package:flutter/material.dart';
import 'dart:io';

import '../schemas/result.dart';
import '../utils/format.dart';

class ResultsPage extends StatelessWidget {
  final File imageFile;
  final PredictionResult result;

  const ResultsPage({super.key, required this.imageFile, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Resultado da Classificação")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<String>(
              future: getLabelById(
                result.classIndex,
              ), // Carrega a classe de forma assíncrona
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Exibe um indicador de carregamento
                } else if (snapshot.hasError) {
                  return const Text(
                    "Erro ao carregar a classe",
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  );
                } else {
                  return Text(
                    "Classe: ${snapshot.data}", // Exibe a classe carregada
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
              },
            ),
            Image.file(imageFile, width: 300, height: 300, fit: BoxFit.cover),
            const SizedBox(height: 20),
            Text(
              "Confiança: ${formatToPercentage(result.score)}", // Exibe o resultado da predição
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
