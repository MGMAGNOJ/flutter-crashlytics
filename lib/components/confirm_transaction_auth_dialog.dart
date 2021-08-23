import 'package:flutter/material.dart';

class ConfirmTransactionAuthDialog extends StatefulWidget {
  final Function(String password) onconfirm;

  ConfirmTransactionAuthDialog({@required required this.onconfirm});

  @override
  _ConfirmTransactionAuthDialogState createState() =>
      _ConfirmTransactionAuthDialogState();
}

class _ConfirmTransactionAuthDialogState
    extends State<ConfirmTransactionAuthDialog> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirmação requerida'),
      content: TextField(
        controller: _passwordController,
        decoration: InputDecoration(border: OutlineInputBorder()),
        obscureText: true,
        maxLength: 4,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: TextStyle(
          fontSize: 64,
          letterSpacing: 24,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            widget.onconfirm(_passwordController.text);
            Navigator.of(context).pop();
          },
          child: Text('Confirmar'),
        ),
      ],
    );
  }
}
