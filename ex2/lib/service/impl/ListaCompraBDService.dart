import 'package:sqflite/sqflite.dart';
import '../../model/ListaCompra.dart';
import '../BDService.dart';
import '../ListaCompraService.dart';
import '../../errors/ErrorClasses.dart';

class ListaCompraBDService extends ListaCompraService {
  final bdService = BDService();
  final String _tableName = 'listas_compra';

  @override
  Future<List<ListaCompra>> getAll() async {
    final bd = await bdService.database;
    final List<Map<String, dynamic>> maps = await bd.query(_tableName, orderBy: 'nome');
    return List.generate(maps.length, (i) {
      return ListaCompra.fromMap(maps[i]);
    });
  }

  @override
  Future<void> insert(ListaCompra lista) async {
    final bd = await bdService.database;
    try {
      await bd.insert(_tableName, lista.toMap());
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw NomeDuplicadoException();
      }
      rethrow;
    }
  }

  @override
  Future<void> update(ListaCompra lista) async {
    final bd = await bdService.database;
    await bd.update(
      _tableName,
      lista.toMap(),
      where: 'id = ?',
      whereArgs: [lista.id],
    );
  }

  @override
  Future<void> delete(ListaCompra lista) async {
    final bd = await bdService.database;
    await bd.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [lista.id],
    );
  }
}