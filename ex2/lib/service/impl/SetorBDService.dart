import 'package:sqflite/sqflite.dart';
import '../../model/Setor.dart';
import '../BDService.dart';
import '../SetorService.dart';
import '../../errors/ErrorClasses.dart';

class SetorBDService extends SetorService {
  final bdService = BDService();

  @override
  Future<List<Setor>> getAll() async {
    final bd = await bdService.database;
    final List<Map<String, dynamic>> maps = await bd.query('setores', orderBy: 'nome');
    return List.generate(maps.length, (i) {
      return Setor.fromMap(maps[i]);
    });
  }

  @override
  Future<void> insert(Setor setor) async {
    final bd = await bdService.database;
    try {
      await bd.insert('setores', setor.toMap());
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw NomeDuplicadoException();
      }
      rethrow;
    }
  }

  @override
  Future<void> update(Setor setor) async {
    final bd = await bdService.database;
    await bd.update(
      'setores',
      setor.toMap(),
      where: 'id = ?',
      whereArgs: [setor.id],
    );
  }

  @override
  Future<void> delete(Setor setor) async {
    final bd = await bdService.database;
    try {
      await bd.delete('setores', where: 'id = ?', whereArgs: [setor.id]);
    } on DatabaseException catch (e) {
      if (e.toString().contains('FOREIGN KEY constraint failed')) {
        throw SetorEmUsoException();
      }
      rethrow;
    }
  }
}