class ListaCompra implements Comparable<ListaCompra> {
  int? id;
  String nome;

  ListaCompra({this.id, required this.nome});

  factory ListaCompra.fromMap(Map<String, dynamic> map) {
    return ListaCompra(
      id: map['id'],
      nome: map['nome'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ListaCompra &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(ListaCompra other) {
    return nome.toLowerCase().compareTo(other.nome.toLowerCase());
  }
}