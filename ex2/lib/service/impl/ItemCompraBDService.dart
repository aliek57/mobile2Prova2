import 'package:sqflite/sqflite.dart';
import '../../model/ItemCompra.dart';
import '../BDService.dart';
import '../ItemCompraService.dart';
import '../../errors/ErrorClasses.dart';

class ItemCompraBDService extends ItemCompraService {
  final bdService = BDService();
  final String _tableName = 'itens_compra';

  @override
  Future<List<ItemCompra>> getByListaCompraId(int listaCompraId) async {
    final bd = await bdService.database;
    final List<Map<String, dynamic>> maps = await bd.rawQuery('''
      SELECT 
        i.id, i.nome, i.comprado, i.lista_compra_id, i.setor_id, s.nome as nomeSetor
      FROM itens_compra i
      JOIN setores s ON i.setor_id = s.id
      WHERE i.lista_compra_id = ?
    ''', [listaCompraId]);

    return List.generate(maps.length, (i) {
      return ItemCompra.fromMap(maps[i]);
    });
  }

  @override
  Future<void> insert(ItemCompra item) async {
    final bd = await bdService.database;
    try {
      await bd.insert(_tableName, item.toMap());
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw NomeDuplicadoException();
      }
      rethrow;
    }
  }

  @override
  Future<void> update(ItemCompra item) async {
    final bd = await bdService.database;
    await bd.update(
      _tableName,
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  @override
  Future<void> delete(ItemCompra item) async {
    final bd = await bdService.database;
    await bd.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }
}