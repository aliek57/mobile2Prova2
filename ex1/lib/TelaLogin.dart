import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'TelaJogo.dart';
import 'Jogador.dart';

class TelaLogin extends StatefulWidget {
  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _nomeController = TextEditingController();

  List<Jogador> _ranking = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarRanking();
  }

  Future<void> _carregarRanking() async {
    final prefs = await SharedPreferences.getInstance();
    final chaves = prefs.getKeys();
    final List<Jogador> listaJogadores = [];

    for (String chave in chaves) {
      final placarString = prefs.getString(chave);
      if (placarString != null) {
        final placar = Map<String, int>.from(json.decode(placarString));
        listaJogadores.add(Jogador(
          chave,
          placar['acertos'] ?? 0,
          placar['erros'] ?? 0,
        ));
      }
    }

    listaJogadores.sort((a, b) => b.pontuacao.compareTo(a.pontuacao));

    setState(() {
      _ranking = listaJogadores;
      _carregando = false;
    });
  }

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

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaJogo(
          nomeJogador: nomeJogador,
          placarInicial: placar,
        ),
      ),
    );

    _carregarRanking();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Treinar Tabuada'),
      ),
      body: SingleChildScrollView(
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
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 20),
              const Text('Ranking', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              _carregando
                  ? const Center(child: CircularProgressIndicator())
                  : _ranking.isEmpty
                  ? const Center(child: Text('Nenhum jogador no ranking ainda.'))
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _ranking.length,
                itemBuilder: (context, index) {
                  final jogador = _ranking[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(jogador.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${jogador.acertos} acertos, ${jogador.erros} erros'),
                    trailing: Text('${jogador.pontuacao} pts', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}