import 'dart:async';

import 'package:alura_crashlytics/components/confirm_transaction_auth_dialog.dart';
import 'package:alura_crashlytics/components/response_dialog.dart';
import 'package:alura_crashlytics/components/waiting.dart';
import 'package:alura_crashlytics/http/web_clients/transaction_webclient.dart';
import 'package:alura_crashlytics/models/contatos.dart';
import 'package:alura_crashlytics/models/transaction.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TransactionForm extends StatefulWidget {
  final Contato contato;

  TransactionForm(this.contato);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();
  final TransactionWebClient _transactionWebClient = TransactionWebClient();
  final _ScaffoldState = GlobalKey<ScaffoldState>();


  // gerador de UUID;

  final String transactionId = Uuid().v4();

  bool _boolProcessando = false;

  @override
  Widget build(BuildContext context) {
    print('Transaction Form ID: $transactionId');
    return Scaffold(
      key: _ScaffoldState,
      appBar: AppBar(
        title: Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Barra de Processando transação
              Visibility(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Waiting(mensagem: 'Processando'),
                ),
                visible: _boolProcessando,
              ),

              // Campo do Nome
              Text(
                widget.contato.nome,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),

              // Campo de digitação do Valor
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  widget.contato.numeroDaConta.toString(),
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(labelText: 'Value'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              // Botão de enviar
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: Text('Transfer'),
                    onPressed: () {
                      final double? value =
                          double.tryParse(_valueController.text);
                      if (value != null) {
                        final transactionCreated = Transaction(
                          transactionId,
                          value,
                          widget.contato,
                        );
                        showDialog(
                            context: context,
                            builder: (contextDialog) {
                              return ConfirmTransactionAuthDialog(
                                onconfirm: (String password) {
                                  _save(transactionCreated, password, context);
                                },
                              );
                            });
                      } else {
                        showDialog(
                            context: (context),
                            builder: (contextDialog) {
                              return FailureDialog('Campo valor Vazio');
                            });
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _save(
    Transaction transactionCreated,
    String password,
    BuildContext context,
  ) async {
    // Habilita visibilidade do icone de processanndo
    setState(() {
      _boolProcessando = true;
    });
    // Processa a transação
    Transaction? transaction = await _send(
      transactionCreated,
      password,
      context,
    );
    // Desabilita visibilidade do icone de processanndo

    setState(() {
      _boolProcessando = false;
    });

    // Mostra mensagem de Sucesso
    if (transaction != null) {
      await showDialog(
          context: context,
          builder: (contextDialog) {
            return SuccessDialog("Show");
          });
      Navigator.of(context).pop();
    }
  }

  Future<Transaction?> _send(Transaction transactionCreated, String password,
      BuildContext context) async {
    final Transaction? transaction = await _transactionWebClient
        .save(
      transactionCreated,
      password,
    )
        // Get de erro específico
        .catchError((e) {
      // Criando erros para o Firebase Analisando na WEB
      _FirebaseTWC(e, transactionCreated);

      _ShowFailMessage(context, mensagem: 'Timeout HTTP');
    }, test: (e) => e is TimeoutException)
        // Get de erro mais geral.
        .catchError((e) {
      // Criando erros para o Firebase Analisando na WEB
      _FirebaseTWC(e, transactionCreated);
      _ShowFailMessage(context, mensagem: e.toString());
    }, test: (e) => e is Exception)
        // Get Genérico dos erros
        .catchError((e) {
      // Criando erros para o Firebase Analisando na WEB
      _FirebaseTWC(e, transactionCreated);
      _ShowFailMessage(context);
    });
    return transaction;
  }

  // Gera o Erro do Firebase
  void _FirebaseTWC(e, Transaction transactionCreated) {
    if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
      // Criando erros para o Firebase Analisando na WEB
      FirebaseCrashlytics.instance.setCustomKey('HTTPError', e.toString());
      FirebaseCrashlytics.instance
          .setCustomKey('Transaction', transactionCreated.toString());
      FirebaseCrashlytics.instance.recordError(e, null);
    }
  }

  void _ShowFailMessage (BuildContext context,
      {String mensagem = 'Erro desconhecido'}) {

    final _snackBar = SnackBar(content: Text(mensagem));
    ScaffoldMessenger.of(context).showSnackBar(_snackBar);

    Fluttertoast.showToast(
        msg: mensagem,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );

    showDialog(
        context: (context),
        builder: (contextDialog) {
          return FailureDialog(mensagem);
        });
  }
}
