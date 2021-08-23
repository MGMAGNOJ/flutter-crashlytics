import 'package:bytebankapp/database/dao/contatos_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  // Usando o Database com a função async Forma detalhada.
  final String dbpath = await getDatabasesPath();
  final String path = join(dbpath, 'byteBank01.db');
  //byteBank.db é o nome do arquivo que representará o banco de dados
  return openDatabase(path, onCreate: (db, version) {
    db.execute(ContatoDAO.createTableSQL);
  }, version: 4, onDowngrade: onDatabaseDowngradeDelete);
}
