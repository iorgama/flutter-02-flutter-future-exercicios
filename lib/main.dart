import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Futures',
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyText1: TextStyle(color: Colors.blue, fontSize: 20),
          bodyText2: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Future<String> getFutureArquivos() async =>
    await Future.delayed(const Duration(seconds: 5), () async {
      try {
        final jsonData = await rootBundle.loadString("assets/user2.json");
        final parsedJson = json.decode(jsonData);

        final name = parsedJson['nome'];
        final birthday = parsedJson['nascimento'].replaceAll('-', '/');

        return '$name e $birthday';
      } catch (error) {
        return 'Arquivo inválido. Erro: $error';
      }
    });

class _MyHomePageState extends State<MyHomePage> {
  bool visiblity = false;
  bool showData = false;
  String data = '';

  Future<void> handlePress() async {
    setState(() {
      visiblity = true;
    });
    final file = await getFutureArquivos();
    setState(() {
      data = file;
      showData = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!visiblity)
              ElevatedButton(
                onPressed: handlePress,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80),
                  ),
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                ),
                child: Text('Clique aqui',
                    style: Theme.of(context).textTheme.bodyText2),
              ),
            if (visiblity && !showData) const CircularProgressIndicator(),
            if (showData)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(data,
                        style: Theme.of(context).textTheme.bodyText1),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        data = '';
                        showData = false;
                        visiblity = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80),
                      ),
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 100, vertical: 20),
                    ),
                    child: Text('Voltar',
                        style: Theme.of(context).textTheme.bodyText2),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
