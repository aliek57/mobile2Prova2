import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/ItemCompra.dart';
import '../../model/Setor.dart';
import '../viewmodels/ListaCompraViewModel.dart';

class TelaItemCompra extends StatefulWidget {
  const TelaItemCompra({super.key});

  @override
  State<TelaItemCompra> createState() => _TelaItemCompraState();
}

class _TelaItemCompraState extends State<TelaItemCompra> {
  late StreamSubscription _snackbarSubscription;
  late ListaCompraViewModel _vm;

  Setor? _setorFiltrado;

  @override
  void initState() {
    super.initState();
    _vm = Provider.of<ListaCompraViewModel>(context, listen: false);
    _snackbarSubscription = _vm.snackbarStream.listen((msg) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    });
  }

  @override
  void dispose() {
    _vm.deselecionarLista();
    _snackbarSubscription.cancel();
    super.dispose();
  }

  void _showAddItemDialog(BuildContext context) {
    final vm = Provider.of<ListaCompraViewModel>(context, listen: false);
    final nomeController = TextEditingController();
    Setor? setorSelecionado;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Novo Item'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nomeController,
                    autofocus: true,
                    decoration: const InputDecoration(labelText: 'Nome do item'),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<Setor>(
                    value: setorSelecionado,
                    hint: const Text('Selecione um setor'),
                    isExpanded: true,
                    items: vm.setoresDisponiveis.map((setor) {
                      return DropdownMenuItem(value: setor, child: Text(setor.nome));
                    }).toList(),
                    onChanged: (Setor? novoValor) {
                      setDialogState(() {
                        setorSelecionado = novoValor;
                      });
                    },
                    validator: (value) => value == null ? 'Campo obrigatório' : null,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('Salvar'),
                  onPressed: () {
                    if (nomeController.text.isNotEmpty && setorSelecionado != null) {
                      vm.adicionarItem(nomeController.text, setorSelecionado!);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ListaCompraViewModel>(
      builder: (context, vm, child) {
        final List<ItemCompra> itensExibidos;
        if (_setorFiltrado == null) {
          itensExibidos = vm.itensDaLista;
        } else {
          itensExibidos = vm.itensDaLista.where((item) => item.setorId == _setorFiltrado!.id).toList();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(vm.tituloAppBar),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<Setor>(
                  value: _setorFiltrado,
                  isExpanded: true,
                  hint: const Text('Filtrar por setor...'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Todos os Setores')),
                    ...vm.setoresDisponiveis.map((setor) {
                      return DropdownMenuItem(value: setor, child: Text(setor.nome));
                    }),
                  ],
                  onChanged: (Setor? novoValor) {
                    setState(() {
                      _setorFiltrado = novoValor;
                    });
                  },
                ),
              ),

              Expanded(
                child: vm.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : itensExibidos.isEmpty
                    ? const Center(child: Text('Nenhum item nesta lista ou setor.'))
                    : ListView.builder(
                  itemCount: itensExibidos.length,
                  itemBuilder: (context, index) {
                    final item = itensExibidos[index];
                    return Card(
                      color: item.comprado ? Colors.grey.shade300 : null,
                      child: ListTile(
                        leading: Checkbox(
                          value: item.comprado,
                          onChanged: (bool? value) {
                            vm.marcarComoComprado(item, value ?? false);
                          },
                        ),
                        title: Text(
                          item.nome,
                          style: TextStyle(
                            decoration: item.comprado
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        subtitle: Text(item.nomeSetor ?? 'Sem setor'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => vm.excluirItem(item),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddItemDialog(context),
            tooltip: 'Novo Item',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}