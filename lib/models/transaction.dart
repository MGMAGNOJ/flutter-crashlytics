import 'package:alura_crashlytics/models/contatos.dart';

class Transaction {
  final String id;
  final double value;
  final Contato contact;

  Transaction(
    this.id,
    this.value,
    this.contact,
  );

  Transaction.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        value = json['value'],
        contact = Contato.fromJson(json['contact']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'value': value,
        'contact': contact.toJson(),
      };

  @override
  String toString() {
    return 'Transaction{id: $id, value: $value, contact: $contact}';
  }
}
