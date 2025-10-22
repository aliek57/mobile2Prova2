import 'dart:async';
import 'package:ex2/utils/FormatarTexto.dart';
import 'package:flutter/material.dart';
import '../../errors/ErrorClasses.dart';
import '../../model/ItemCompra.dart';
import '../../model/ListaCompra.dart';
import '../../model/Setor.dart';
import '../../service/impl/ItemCompraBDService.dart';
import '../../service/impl/ListaCompraBDService.dart';
import '../../service/impl/SetorBDService.dart';
import '../../service/ItemCompraService.dart';
import '../../service/ListaCompraService.dart';
import '../../service/SetorService.dart';

class ListaCompraViewModel extends ChangeNotifier {
  final ListaCompraService _listaCompraService = ListaCompraBDService();
  final ItemCompraService _itemCompraService = ItemCompraBDService();
  final SetorService _setorService = SetorBDService();

  final _snackbarController = StreamController<String>.broadcast();
  Stream<String> get snackbarStream => _snackbarController.stream;

  final TextEditingController nomeListaController = TextEditingController();
  final TextEditingController nomeItemController = TextEditingController();

  List<ListaCompra> _listasCompra = [];
  List<ItemCompra> _itensDaLista = [];
  List<Setor> _setoresDisponiveis = [];
  ListaCompra? _listaSelecionada;
  bool _isLoading = false;

  List<ListaCompra> get listasCompra => _listasCompra;
  List<ItemCompra> get itensDaLista => _itensDaLista;
  List<Setor> get setoresDisponiveis => _setoresDisponiveis;
  ListaCompra? get listaSelecionada => _listaSelecionada;
  bool get isLoading => _isLoading;
  String get tituloAppBar => _listaSelecionada?.nome ?? "Listas de Compras";

  ListaCompraViewModel() {
    _init();
  }

  @override
  void dispose() {
    _snackbarController.close();
    super.dispose();
  }

  Future<void> _init() async {
    await carregarListasCompra();
    await carregarSetores();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> carregarListasCompra() async {
    _setLoading(true);
    try {
      _listasCompra = await _listaCompraService.getAll();
      _listasCompra.sort();
    } catch (e) {
      _snackbarController.sink.add("Erro ao carregar as listas de compra.");
    }
    _setLoading(false);
  }

  Future<void> salvarListaCompra(String nome) async {
    final nomeNormalizado = normalizarString(nome);
    if (nomeNormalizado.isEmpty) {
      _snackbarController.sink.add("O nome da lista não pode ser vazio.");
      return;
    }
    try {
      final novaLista = ListaCompra(nome: nomeNormalizado);
      await _listaCompraService.insert(novaLista);
      await carregarListasCompra();
    } on NomeDuplicadoException {
      _snackbarController.sink.add("Já existe uma lista com o nome '$nome'.");
    } catch (e) {
      _snackbarController.sink.add("Ocorreu um erro inesperado ao salvar a lista.");
    }
  }

  Future<void> excluirListaCompra(ListaCompra lista) async {
    _setLoading(true);
    await _listaCompraService.delete(lista);
    await carregarListasCompra();
    _setLoading(false);
  }

  Future<void> carregarSetores() async {
    _setoresDisponiveis = await _setorService.getAll();
    _setoresDisponiveis.sort();
    notifyListeners();
  }

  Future<void> selecionarLista(ListaCompra lista) async {
    _listaSelecionada = lista;
    await carregarSetores();
    await carregarItensDaLista();
  }

  void deselecionarLista() {
    _listaSelecionada = null;
    _itensDaLista = [];
  }

  Future<void> carregarItensDaLista() async {
    if (_listaSelecionada == null) return;
    _setLoading(true);
    _itensDaLista = await _itemCompraService.getByListaCompraId(_listaSelecionada!.id!);
    _itensDaLista.sort();
    _setLoading(false);
  }

  Future<void> adicionarItem(String nome, Setor setor) async {
    final nomeNormalizado = normalizarString(nome);
    if (nomeNormalizado.isEmpty) {
      _snackbarController.sink.add("O nome do item não pode ser vazio.");
      return;
    }
    final novoItem = ItemCompra(
      nome: nomeNormalizado,
      listaCompraId: _listaSelecionada!.id!,
      setorId: setor.id!,
    );
    await _itemCompraService.insert(novoItem);
    await carregarItensDaLista();
  }

  Future<void> marcarComoComprado(ItemCompra item, bool comprado) async {
    item.comprado = comprado;
    await _itemCompraService.update(item);
    await carregarItensDaLista();
  }

  Future<void> excluirItem(ItemCompra item) async {
    await _itemCompraService.delete(item);
    await carregarItensDaLista();
  }
}