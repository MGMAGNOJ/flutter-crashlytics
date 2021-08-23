import 'package:flutter/material.dart';

class Waiting extends StatelessWidget {

  final String mensagem;

  Waiting({this.mensagem = 'Carregando'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              this.mensagem,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

}
