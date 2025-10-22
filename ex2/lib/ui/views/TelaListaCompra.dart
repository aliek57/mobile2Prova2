import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/ListaCompra.dart';
import '../viewmodels/ListaCompraViewModel.dart';
import 'TelaItemCompra.dart';
import 'TelaSetor.dart';

class TelaListaCompra extends StatefulWidget {
  const TelaListaCompra({super.key});

  @override
  State<TelaListaCompra> createState() => _TelaListaCompraState();
}

class _TelaListaCompraState extends State<TelaListaCompra> {
  late StreamSubscription _snackbarSubscription;

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<ListaCompraViewModel>(context, listen: false);
    _snackbarSubscription = vm.snackbarStream.listen((msg) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    });
  }

  @override
  void dispose() {
    _snackbarSubscription.cancel();
    super.dispose();
  }

  void _abrirTelaItens(BuildContext context, ListaCompra lista) {
    final vm = Provider.of<ListaCompraViewModel>(context, listen: false);
    vm.selecionarLista(lista);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TelaItemCompra()),
    );
  }

  void _abrirTelaSetores(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TelaSetor()),
    );
  }

  void _showAddListaDialog(BuildContext context) {
    final vm = Provider.of<ListaCompraViewModel>(context, listen: false);
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nova Lista de Compras'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Nome da lista'),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Salvar'),
              onPressed: () {
                vm.salvarListaCompra(controller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showConfirmDeleteDialog(BuildContext context, ListaCompra lista) {
    final vm = Provider.of<ListaCompraViewModel>(context, listen: false);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Excluir Lista'),
          content: Text('Tem certeza que deseja excluir a lista "${lista.nome}"? Todos os itens dela serão perdidos.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                vm.excluirListaCompra(lista);
                Navigator.of(context).pop();
              },
              child: Text('Excluir'),
            ),
          ],
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Listas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Gerenciar Setores',
            onPressed: () => _abrirTelaSetores(context),
          ),
        ],
      ),
      body: Consumer<ListaCompraViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.listasCompra.isEmpty) {
            return const Center(
              child: Text('Nenhuma lista de compras. Crie uma no botão +'),
            );
          }

          return ListView.builder(
            itemCount: vm.listasCompra.length,
            itemBuilder: (context, index) {
              final lista = vm.listasCompra[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Text(lista.nome),
                  onTap: () => _abrirTelaItens(context, lista),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _showConfirmDeleteDialog(context, lista),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddListaDialog(context),
        tooltip: 'Nova Lista',
        child: const Icon(Icons.add),
      ),
    );
  }
}