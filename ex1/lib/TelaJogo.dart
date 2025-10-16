import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaJogo extends StatefulWidget {
  final String nomeJogador;
  final Map<String, int> placarInicial;

  const TelaJogo({
    super.key,
    required this.nomeJogador,
    required this.placarInicial,
  });

  @override
  State<TelaJogo> createState() => _TelaJogoState();
}

class _TelaJogoState extends State<TelaJogo> {
  int _numero1 = 0;
  int _numero2 = 0;
  late int _pontos;
  late int _erros;
  final _respostaController = TextEditingController();

  Timer? _timer;
  int _tempoRestante = 20;
  int _tempoMaximo = 20;
  int _errosConsecutivos = 0;

  @override
  void initState() {
    super.initState();
    _pontos = widget.placarInicial['acertos']!;
    _erros = widget.placarInicial['erros']!;
    _gerarNovaPergunta();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _respostaController.dispose();
    super.dispose();
  }

  void _iniciarTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_tempoRestante > 0) {
          _tempoRestante--;
        } else {
          _timer?.cancel();
          _verificarResposta(tempoEsgotado: true);
        }
      });
    });
  }

  void _gerarNovaPergunta() {
    setState(() {
      _tempoRestante = _tempoMaximo;
      _numero1 = Random().nextInt(10) + 1;
      _numero2 = Random().nextInt(10) + 1;
      _respostaController.clear();
    });
    _iniciarTimer();
  }

  void _verificarResposta({bool tempoEsgotado = false}) {
    _timer?.cancel();

    final int? respostaUsuario = int.tryParse(_respostaController.text);
    final int respostaCorreta = _numero1 * _numero2;
    String motivoErro = "Resposta incorreta. A correta era $respostaCorreta";

    if (tempoEsgotado) {
      motivoErro = "Tempo esgotado! A resposta era $respostaCorreta";
    }

    setState(() {
      if (!tempoEsgotado && respostaUsuario == respostaCorreta) {
        _pontos++;
        _errosConsecutivos = 0;
        if (_tempoMaximo > 5) {
          _tempoMaximo--;
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Acertou! Próxima pergunta com $_tempoMaximo s'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1)));
      } else {
        _erros++;
        _errosConsecutivos++;
        if (_errosConsecutivos >= 2) {
          if (_tempoMaximo < 30) {
            _tempoMaximo++;
          }
          _errosConsecutivos = 0;
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(motivoErro),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2)));
      }
    });

    _salvarPlacar();

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _gerarNovaPergunta();
      }
    });
  }

  Future<void> _salvarPlacar() async {
    final prefs = await SharedPreferences.getInstance();
    final placar = {'acertos': _pontos, 'erros': _erros};
    prefs.setString(widget.nomeJogador, json.encode(placar));
  }

  void _reiniciarEstatisticas() {
    setState(() {
      _pontos = 0;
      _erros = 0;
      _errosConsecutivos = 0;
      _tempoMaximo = 20;
    });
    _salvarPlacar();
    _gerarNovaPergunta();
  }

  void _voltarParaLogin() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pontos: $_pontos | Erros: $_erros'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reiniciar Placar',
            onPressed: _reiniciarEstatisticas,
          ),
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Voltar ao Início',
            onPressed: _voltarParaLogin,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Tempo: $_tempoRestante',
                  style: TextStyle(
                      fontSize: 28,
                      color: _tempoRestante <= 5 ? Colors.red : Colors.blue,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Text('Quanto é $_numero1 x $_numero2 ?',
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              TextField(
                controller: _respostaController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24),
                decoration: const InputDecoration(
                    labelText: 'Sua Resposta', border: OutlineInputBorder()),
                onSubmitted: (_) => _verificarResposta(),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _verificarResposta(),
                  child: const Text('Verificar', style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}