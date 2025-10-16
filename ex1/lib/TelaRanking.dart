import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Jogador.dart';

class TelaRanking extends StatefulWidget {
  const TelaRanking({super.key});

  @override
  State<TelaRanking> createState() => _TelaRankingState();
}

class _TelaRankingState extends State<TelaRanking> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ranking de Jogadores'),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _ranking.isEmpty
            ? const Center(child: Text('Nenhum jogador no ranking ainda.'))
            : ListView.builder(
              itemCount: _ranking.length,
              itemBuilder: (context, index) {
                final jogador = _ranking[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(
                    jogador.nome,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${jogador.acertos} acertos, ${jogador.erros} erros'),
                  trailing: Text(
                    '${jogador.pontuacao} pts',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          );
        },
      ),
    );
  }
}