import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/Setor.dart';
import '../viewmodels/SetorViewModel.dart';

class TelaSetor extends StatefulWidget {
  const TelaSetor({super.key});

  @override
  State<TelaSetor> createState() => _TelaSetorState();
}

class _TelaSetorState extends State<TelaSetor> {
  late StreamSubscription _snackbarSubscription;

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<SetorViewModel>(context, listen: false);

    _snackbarSubscription = vm.snackbarStream.listen((msg) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    });
  }

  @override
  void dispose() {
    _snackbarSubscription.cancel();
    super.dispose();
  }

  void _showConfirmDeleteDialog(BuildContext context, Setor setor) {
    final vm = Provider.of<SetorViewModel>(context, listen: false);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Excluir Setor'),
          content: Text('Tem certeza que deseja excluir o setor "${setor.nome}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                vm.excluirSetor(setor);
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
    return Consumer<SetorViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Gerenciar Setores'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  controller: vm.nomeController,
                  decoration: InputDecoration(
                    labelText: vm.emModoEdicao ? 'Editar Setor' : 'Novo Setor',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: vm.cancelarEdicao,
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: vm.salvarSetor,
                      child: Text(vm.emModoEdicao ? 'Atualizar' : 'Salvar'),
                    ),
                  ],
                ),
                const Divider(height: 20),

                if (vm.isLoading)
                  const Expanded(child: Center(child: CircularProgressIndicator()))
                else if (vm.setores.isEmpty)
                  const Expanded(
                      child: Center(child: Text('Nenhum setor cadastrado.')))
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: vm.setores.length,
                      itemBuilder: (context, index) {
                        final setor = vm.setores[index];
                        return Card(
                          child: ListTile(
                            title: Text(setor.nome),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => vm.editarSetor(setor),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _showConfirmDeleteDialog(context, setor),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}