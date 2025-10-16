class Jogador {
  String nome;
  int acertos, erros;

  Jogador(this.nome, this.acertos, this.erros);

  int get pontuacao => acertos - erros;
}