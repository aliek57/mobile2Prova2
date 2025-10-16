## Exercício 1 - Treinar Tabuada ##

Crie um aplicativo em Flutter para auxiliar no treino da tabuada para alunos do ensino fundamental. Após iniciar, o aplicativo deverá sortear dois número de 1 a 10, mostrando a expressão resultante para o usuário. A partir daí, o usuário terá um tempo (iniciando com 20
segundos) para responder. Cada questão terá uma chance de resposta. Um acerto será computado se o usuário informar a resposta correta no tempo disponível, caso contrário será computado um erro.

O aplicativo deverá armazenar localmente o nome e o placar dos jogadores. Ao iniciar, o jogador deverá informar seu nome, e o aplicativo deverá buscar o placar anterior do mesmo. Se não encontrar, iniciar um novo placar para este jogador.

A cada questão respondida corretamente, o tempo deverá ser diminuído para a próxima questão. A partir de 2 erros seguidos, o tempo deverá ser aumentado para a próxima questão.

Na barra de ações, devem ser mostrados dois ícones: um para reiniciar as estatísticas do jogador, e outro para sair do aplicativo.

Deve ser incluído uma forma de mostrar o ranking dos jogadores. Para classificação, deve ser considerado o número de acertos descontado do número de erros.


## Exercício 2 - Lista de Compras com Armazenamento SQLite ##

Desenvolva um aplicativo em Flutter com armazenamento em SQLite, para gerenciar listas de compras de um pessoa. O aplicativo deve ser implementado usando o padrão *MVVM (Model-View-ViewModel)*. Devem estar presentes as seguintes funcionalidades (outras podem ser acrescentadas):

• Na tela inicial devem ser mostradas as listas de compra a serem efetuadas. Pense no caso em que a pessoa deve ir a um local específico (farmácia, supermercado, loja de utilidades, loja de ferramentas), ou outras listas que consiga imaginar. Devem ser disponibilizadas opções
para criar/alterar/excluir uma lista de compras, e outra opção para realizar a compra da lista selecionada.

• Cada lista terá um nome que a identifique, e ao clicar na lista, deve ser aberta nova tela com a lista dos itens (produtos) a comprar (tela de compras)

• Deve ser possível fazer a manutenção de uma lista de setores a partir de um menu/action da tela principal. Para cada item adicionado numa lista de compras, deve ser escolhido um setor. Por exemplo, numa lista de mercado, os setores podem ser: limpeza, higiene, frutas e
verduras, carnes, padaria.

• Para a criação de uma lista de compras deve ser possível definir um nome para a lista, e então, repetidamente, escolher um dos setores cadastrados e incluir os itens a comprar neste setor.

• Na tela de compras deverá ser possível que o usuário escolha um dos setores cadastrados, e o aplicativo deve listar os produtos a comprar neste setor, ou mostrar uma mensagem se não houver itens a comprar. Listar os itens a comprar, devendo ser possível marcar o item como
“comprado”, para conferência. Exemplo: o item já comprado pode ficar em outra cor e ir para o final da lista.

• *Incremento (opcional, mas desejável):* Fornecer uma forma rápida de consultar a quantidade que falta comprar, bem como para localizar os itens faltantes (sem ter que entrar nos departamentos). Ex: uma opção “Todos” na seleção dos departamentos.
