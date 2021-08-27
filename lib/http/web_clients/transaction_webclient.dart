import 'dart:convert';

import 'package:alura_crashlytics/models/transaction.dart';
import 'package:alura_crashlytics/web-api/webclient.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class TransactionWebClient {
  Future<List<Transaction>> findAll() async {
    // Verificação do timeout da rede IMPORTANTE
    final Response response = await client.get(url).timeout(
          Duration(seconds: 3),
        );

    final List<dynamic> decodeJson = jsonDecode(response.body);
    return decodeJson.map((dynamic json) {
      return Transaction.fromJson(json);
    }).toList();
  }

  Future<Transaction?> save(Transaction transaction, String password) async {
    final String transactionJson = jsonEncode(transaction.toJson());

    await Future.delayed(Duration(seconds: 10));

    final Response response = await client
        .post(url,
            headers: {
              'Content-type': 'application/json',
              'password': password,
            },
            body: transactionJson)
        .timeout(Duration(seconds: 3));

    switch (response.statusCode) {
      case 200:
        {
          return Transaction.fromJson(jsonDecode(response.body));
        }
      default:
        if (_HTTPStatusResponses[response.statusCode] != null){



          throw Exception(_HTTPStatusResponses[response.statusCode]);
        } else {
          throw Exception(response.statusCode);
        }

    }
  }

  static final Map<int, String> _HTTPStatusResponses = {
    400: 'Campo faltante',
    401: 'Senha incorreta',
    409: 'Transação duplicada',
  };
}
