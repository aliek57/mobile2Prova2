class ItemCompra implements Comparable<ItemCompra> {
  int? id;
  String nome;
  bool comprado;
  int listaCompraId;
  int setorId;
  String? nomeSetor;

  ItemCompra({
    this.id,
    required this.nome,
    this.comprado = false,
    required this.listaCompraId,
    required this.setorId,
    this.nomeSetor,
  });

  factory ItemCompra.fromMap(Map<String, dynamic> map) {
    return ItemCompra(
      id: map['id'],
      nome: map['nome'],
      comprado: map['comprado'] == 1,
      listaCompraId: map['lista_compra_id'],
      setorId: map['setor_id'],
      nomeSetor: map['nomeSetor'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'comprado': comprado ? 1 : 0,
      'lista_compra_id': listaCompraId,
      'setor_id': setorId,
    };
  }

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
          other is ItemCompra && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(ItemCompra other) {
    if (comprado && !other.comprado) {
      return 1;
    }
    if (!comprado && other.comprado) {
      return -1;
    }
    return nome.toLowerCase().compareTo(other.nome.toLowerCase());
  }
}