import 'package:flutter/material.dart';
import 'dart:io';
//import '../controllers/classify.dart';

class ResultsPage extends StatelessWidget {
  final File imageFile;

  const ResultsPage({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {

    //final classifyController = ClassifyController();

    return Scaffold(
      appBar: AppBar(title: const Text("Imagem Capturada")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Classificação: ',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Image.file(
              imageFile,
              width: 300,
              height: 300,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            const Text(
              'Confiança: ',
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
