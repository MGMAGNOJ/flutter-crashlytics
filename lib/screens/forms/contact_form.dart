import 'package:alura_crashlytics/database/dao/contatos_dao.dart';
import 'package:alura_crashlytics/models/contatos.dart';
import 'package:flutter/material.dart';

class ContactsForm extends StatefulWidget {
  const ContactsForm({Key? key}) : super(key: key);

  @override
  _ContactsFormState createState() {
    return _ContactsFormState();
  }
}

class _ContactsFormState extends State<ContactsForm> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _contaEditingController = TextEditingController();
  final ContatoDAO _contatoDAO = ContatoDAO();

  @override
  Widget build(BuildContext context) {
    // Formulário de entrada de dados container scaffold
    return Scaffold(
      // app bar navegacao e título
      appBar: AppBar(
        title: Text('Form de Cadastro'),
      ),
      // Column para conteúdo
      // column precisa de children
      body: Padding(
        // Padding (Margem da página)
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Textfield para entrada de dados
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: _nameEditingController,
                // Define o título do campo
                decoration: InputDecoration(labelText: 'Nome'),
                // Define o tamanho da fonte
                style: TextStyle(fontSize: 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: _contaEditingController,
                // Define o título do campo
                decoration: InputDecoration(labelText: 'Numero da Conta'),
                // Define o tamanho da fonte
                style: TextStyle(fontSize: 24),
                // Define o teclado numerico
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: () {
                    // Precisamos buscar os valores dos campos
                    final String _nome = _nameEditingController.text;
                    // solução para checagem de int no campo text.
                    // IMPORTANTE
                    final String _contaText = _contaEditingController.text;
                    int _conta = int.tryParse(_contaText) != null
                        ? int.parse(_contaText)
                        : 0;
                    // agora sim executar o processamento
                    final Contato novoContato = Contato(0, _nome, _conta);
                    // Gravando no banco no modo antigo
                    _contatoDAO.save(novoContato).then((id) {
                      Navigator.pop(
                        context,
                      );
                    });
                    // e navegamos para fora
                    //Navigator.pop(context, novoContato);
                  },
                  child: const Text('Cadastrar'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
