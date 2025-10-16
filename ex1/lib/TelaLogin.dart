import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'TelaJogo.dart';
import 'TelaRanking.dart';

class TelaLogin extends StatefulWidget {
  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _nomeController = TextEditingController();

  Future<Map<String, int>> _carregarPlacar(String nomeJogador) async {
    final prefs = await SharedPreferences.getInstance();
    final placarString = prefs.getString(nomeJogador) ?? '';

    if (placarString.isNotEmpty) {
      return Map<String, int>.from(json.decode(placarString));
    } else {
      return {'acertos': 0, 'erros': 0};
    }
  }

  void _iniciarJogo() async {
    final nomeJogador = _nomeController.text.trim();

    if (nomeJogador.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, digite seu nome!')),
      );
      return;
    }

    final placar = await _carregarPlacar(nomeJogador);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaJogo(
          nomeJogador: nomeJogador,
          placarInicial: placar,
        ),
      ),
    );
  }

  void _mostrarRanking() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TelaRanking()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Treinar Tabuada'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Digite seu nome:', style: TextStyle(fontSize: 22)),
              const SizedBox(height: 20),
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nome',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _iniciarJogo,
                  child: const Text('Começar a Jogar!', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: _mostrarRanking,
                child: const Text('Ver Ranking'),
              )
            ],
          ),
        ),
      ),
    );
  }
}