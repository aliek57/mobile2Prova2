class Setor implements Comparable<Setor> {
  int? id;
  String nome;

  Setor({this.id, required this.nome});

  factory Setor.fromMap(Map<String, dynamic> map) {
    return Setor(
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
  bool operator == (Object other) =>
      identical(this, other) ||
          other is Setor && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(Setor other) {
    return nome.toLowerCase().compareTo(other.nome.toLowerCase());
  }
}