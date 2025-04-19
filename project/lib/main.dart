import 'package:flutter/material.dart';

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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
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
                onPressed: () {
                  // Adicione a lógica para abrir a câmera aqui
                  print('Abrir câmera');
                },
                icon: const Icon(Icons.camera_alt),
                iconSize: 120,
                tooltip: "Abrir câmera",
              ),
              const SizedBox(width: 40), // Espaçamento entre os botões
              IconButton(
                onPressed: () {
                  // Adicione a lógica para abrir a câmera aqui
                  print('Abrir galeria');
                },
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
          )
          ],
        )
        
      ),
    );
  }
}
