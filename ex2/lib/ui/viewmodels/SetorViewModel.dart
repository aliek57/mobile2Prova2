import 'dart:async';
import 'package:ex2/utils/FormatarTexto.dart';
import 'package:flutter/material.dart';
import '../../model/Setor.dart';
import '../../service/SetorService.dart';
import '../../service/impl/SetorBDService.dart';
import '../../errors/ErrorClasses.dart';

class SetorViewModel extends ChangeNotifier {
  final SetorService _setorService = SetorBDService();

  final _snackbarController = StreamController<String>.broadcast();
  Stream<String> get snackbarStream => _snackbarController.stream;
  List<Setor> _setores = [];
  bool _isLoading = false;
  Setor? _setorEmEdicao;

  final TextEditingController nomeController = TextEditingController();

  List<Setor> get setores => _setores;
  bool get isLoading => _isLoading;
  bool get emModoEdicao => _setorEmEdicao != null;

  SetorViewModel() {
    _init();
  }

  @override
  void dispose() {
    _snackbarController.close();
    super.dispose();
  }

  Future<void> _init() async {
    await carregarSetores();
  }

  Future<void> carregarSetores() async {
    _setLoading(true);
    try {
      _setores = await _setorService.getAll();
      _setores.sort();
    } catch (e) {
      _snackbarController.sink.add("Ocorreu um erro ao carregar os setores.");
    }
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void editarSetor(Setor setor) {
    _setorEmEdicao = setor;
    nomeController.text = setor.nome;
    notifyListeners();
  }

  void cancelarEdicao() {
    _setorEmEdicao = null;
    nomeController.clear();
    notifyListeners();
  }

  Future<void> salvarSetor() async {
    final nome = normalizarString(nomeController.text);
    if (nome.isEmpty) {
      _snackbarController.sink.add("O nome do setor não pode estar vazio.");
      return;
    }

    try {
      if (emModoEdicao) {
        _setorEmEdicao!.nome = nome;
        await _setorService.update(_setorEmEdicao!);
      } else {
        final novoSetor = Setor(nome: nome);
        await _setorService.insert(novoSetor);
      }
      cancelarEdicao();
      await carregarSetores();
    } on NomeDuplicadoException {
      _snackbarController.sink.add("Já existe um setor com o nome '$nome'.");
    } catch(e) {
      _snackbarController.sink.add("Ocorreu um erro inesperado ao salvar.");
    }
  }

  Future<void> excluirSetor(Setor setor) async {
    try {
      await _setorService.delete(setor);
      await carregarSetores();
    } on SetorEmUsoException {
      _snackbarController.sink.add("Não é possível excluir, o setor '${setor.nome}' está em uso.");
    } catch (e) {
      _snackbarController.sink.add("Ocorreu um erro inesperado ao excluir.");
    }
  }
}