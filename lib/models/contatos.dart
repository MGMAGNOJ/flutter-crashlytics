class Contato {
  final int id;
  final String nome;
  final int numeroDaConta;

  Contato(this.id, this.nome, this.numeroDaConta);
  @override
  String toString() {
    return 'Nome: {valor: $nome, conta: $numeroDaConta}';
  }

  Contato.fromJson(Map<String, dynamic> json)
      : id = json["id"] != null ? (json['id']) : 0,
        nome = json['name'],
        numeroDaConta = json['accountNumber'];

  Map<String, dynamic> toJson() => {
    'name': nome,
    'accountNumber': numeroDaConta,
  };
}
