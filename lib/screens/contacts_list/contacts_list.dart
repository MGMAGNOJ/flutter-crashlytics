import 'package:bytebankapp/database/dao/contatos_dao.dart';
import 'package:bytebankapp/models/contatos.dart';
import 'package:bytebankapp/screens/forms/contact_form.dart';
import 'package:bytebankapp/screens/forms/transaction_form.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatefulWidget {
  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  ContatoDAO _contatoDAO = ContatoDAO();

  @override
  Widget build(BuildContext context) {
    // container da Estrutura da Página
    return Scaffold(
      // Adiciona a barra de título da Página
      appBar: AppBar(
        // Titulo do AppBar
        title: Text('Contatos'),
      ),
      // Contrução dinãmica da lista com base em Banco
      body: FutureBuilder<List<Contato>>(
        // A criação de listas tem que ser determinada como vazia agora.
        initialData: List.empty(),
        future: _contatoDAO.findAll(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              // TODO: Cenario em que o Future não foi executado (Pode ser um botão de Refresh)
              break;
            case ConnectionState.waiting:
              // Apresenta o Loading na tela
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text("Carregando"),
                  ],
                ),
              );
            case ConnectionState.active:
              // Status durante o processamento.
              break;
            case ConnectionState.done:
              // Verificar se a variável está ok antes do carregamento
              if (snapshot.data != null) {
                final List<Contato>? contacts = snapshot.data as List<Contato>;
                // Verificação obrigatória dos nulos
                if (contacts != null) {
                  //feito if para validar nulo
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final Contato contact = contacts[index];
                      return _ContactItem(
                        contact,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TransactionForm(contact),
                            ),
                          );
                        },
                      );
                    },
                    itemCount: contacts.length,
                  );
                }
              }
              break;
          }
          return Text('Erro desconhecido');
        },
      ),
      floatingActionButton: FloatingActionButton(
        //Codigo do floating Button Cuidar com os ( e {
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return ContactsForm();
              },
            ),
          ).then(
            (id) {
              setState(() {});
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final Contato contato;

  // implementa a função de clique
  final Function onTap;

  _ContactItem(this.contato, {@required required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => onTap(),
        title: Text(
          contato.nome,
          style: TextStyle(fontSize: 24.0),
        ),
        subtitle: Text(
          contato.numeroDaConta.toString(),
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
