import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Para manipular o arquivo da imagem

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bem vindo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 242, 242, 243)),
      ),
      home: const MyHomePage(title: 'Template FlutterAI Classify'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _selectedImage; // Variável para armazenar a imagem selecionada

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path); // Armazena a imagem selecionada
      });
    } else {
      print('Nenhuma imagem foi selecionada.');
    }
  }

  Future<void> _takePhotoWithCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path); // Armazena a foto capturada
      });
    } else {
      print('Nenhuma foto foi tirada.');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Center(
          child: Text(widget.title)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Seja bem vindo ao meu template",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28),
            ),
            const SizedBox(height: 20),
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: _takePhotoWithCamera,
                icon: const Icon(Icons.camera_alt),
                iconSize: 120,
                tooltip: "Abrir câmera",
              ),
              const SizedBox(width: 40), // Espaçamento entre os botões
              IconButton(
                onPressed: _pickImageFromGallery,
                icon: const Icon(Icons.photo),
                iconSize: 120,
                tooltip: "Abrir Galeria",
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Escolha uma foto \n como preferir",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28),
          ),
          const SizedBox(height: 20),
          _selectedImage != null 
          ? // Verifica se uma imagem foi selecionada
            Image.file(
              _selectedImage!,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            )
          :
            const Text(
              "Nenhuma imagem selecionada",
              style: TextStyle(fontSize: 18),
            ),
          ],
        )
        
      ),
    );
  }
}
