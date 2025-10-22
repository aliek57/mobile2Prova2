import '../model/Setor.dart';

abstract class SetorService {
  Future<List<Setor>> getAll();
  Future<void> insert(Setor setor);
  Future<void> update(Setor setor);
  Future<void> delete(Setor setor);
}