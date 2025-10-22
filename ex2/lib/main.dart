import 'package:ex2/ui/viewmodels/ListaCompraViewModel.dart';
import 'package:ex2/ui/viewmodels/SetorViewModel.dart';
import 'package:ex2/ui/views/TelaListaCompra.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ListaCompraViewModel()),
        ChangeNotifierProvider(create: (_) => SetorViewModel()),
      ],
      child: MaterialApp(
        title: 'Lista de Compras',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        ),
        debugShowCheckedModeBanner: false,
        home: TelaListaCompra(),
      ),
    );
  }
}