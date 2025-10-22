import '../model/ItemCompra.dart';

abstract class ItemCompraService {
  Future<List<ItemCompra>> getByListaCompraId(int listaCompraId);
  Future<void> insert(ItemCompra item);
  Future<void> update(ItemCompra item);
  Future<void> delete(ItemCompra item);
}