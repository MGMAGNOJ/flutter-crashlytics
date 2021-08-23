import 'dart:async';

import 'package:bytebankapp/components/confirm_transaction_auth_dialog.dart';
import 'package:bytebankapp/components/response_dialog.dart';
import 'package:bytebankapp/components/waiting.dart';
import 'package:bytebankapp/http/web_clients/transaction_webclient.dart';
import 'package:bytebankapp/models/contatos.dart';
import 'package:bytebankapp/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TransactionForm extends StatefulWidget {
  final Contato contato;

  TransactionForm(this.contato);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();
  final TransactionWebClient _transactionWebClient = TransactionWebClient();

  // gerador de UUID;

  final String transactionId = Uuid().v4();

  bool _boolProcessando = false;

  @override
  Widget build(BuildContext context) {
    print('Transaction Form ID: $transactionId');
    return Scaffold(
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
      _ShowFailMessage(context, mensagem: 'Timeout HTTP');
    }, test: (e) => e is TimeoutException)
        // Get de erro mais geral.
        .catchError((e) {
      _ShowFailMessage(context, mensagem: e.toString());
    }, test: (e) => e is Exception)
        // Get Genérico dos erros
        .catchError((e) {
      _ShowFailMessage(context);
    });
    return transaction;
  }

  void _ShowFailMessage(BuildContext context,
      {String mensagem = 'Erro desconhecido'}) {
    showDialog(
        context: (context),
        builder: (contextDialog) {
          return FailureDialog(mensagem);
        });
  }
}
