import 'package:flutter/material.dart';
import 'TelaLogin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exercicio 1 - Prova 2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      debugShowCheckedModeBanner: false,
      home: TelaLogin(),
    );
  }
}