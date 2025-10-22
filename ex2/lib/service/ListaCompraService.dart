import '../model/ListaCompra.dart';

abstract class ListaCompraService {
  Future<List<ListaCompra>> getAll();
  Future<void> insert(ListaCompra lista);
  Future<void> update(ListaCompra lista);
  Future<void> delete(ListaCompra lista);
}