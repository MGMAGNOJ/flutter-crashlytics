import 'package:alura_crashlytics/http/interceptors/Interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';

Client client = InterceptedClient.build(
  interceptors: [LoggerInterceptor()],
  requestTimeout: Duration(seconds: 3),
);
var url = Uri.parse('http://192.168.100.45:8080/transactions');

void findAllOld() async {
  final Response response = await get(Uri.http(
    '192.168.100.40:8080',
    'transactions',
  ));
  // final Response response = await get(Uri.http(
  //   '192.168.100.45:8080',
  //   'transactions',
  // ));

  debugPrint(response.body);
}
