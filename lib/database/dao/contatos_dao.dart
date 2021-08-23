import 'package:bytebankapp/database/database.dart';
import 'package:bytebankapp/models/contatos.dart';
import 'package:sqflite/sqflite.dart';

class ContatoDAO {
  static final String createTableSQL = 'CREATE TABLE $_tableName ('
      '$_id INTEGER PRIMARY KEY, '
      '$_nome TEXT, '
      '$_numeroDaConta INTEGER)';

  static const String _tableName = 'contatos';
  static const String _id = 'id';
  static const String _nome = 'nome';
  static const String _numeroDaConta = 'numeroDaConta';

  Future<int> save(Contato contato) async {
    final Database db = await getDatabase();
    Map<String, dynamic> contactMap = _toMap(contato);
    return db.insert(_tableName, contactMap);
  }

  Map<String, dynamic> _toMap(Contato contato) {
    final Map<String, dynamic> contactMap = Map();
    contactMap[_nome] = contato.nome;
    contactMap[_numeroDaConta] = contato.numeroDaConta;
    return contactMap;
  }

  Future<List<Contato>> findAll() async {
    final Database db = await getDatabase();

    final List<Map<String, dynamic>> resultado = await db.query(_tableName);
    List<Contato> contatos = _toList(resultado);
    return contatos;
  }

  List<Contato> _toList(List<Map<String, dynamic>> resultado) {
    final List<Contato> contatos = [];
    for (Map<String, dynamic> row in resultado) {
      final Contato contato = Contato(
        row[_id],
        row[_nome],
        row[_numeroDaConta],
      );
      contatos.add(contato);
    }
    return contatos;
  }
}
