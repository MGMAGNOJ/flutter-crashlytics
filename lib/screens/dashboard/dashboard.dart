import 'package:bytebankapp/screens/contacts_list/contacts_list.dart';
import 'package:bytebankapp/screens/transactions_list/transactions_list.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard ByteBankApp"),
      ),
      body: Column(
        // Alinhamento entre os componentes
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // Alinhamento Horizontal
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("images/bytebank_logo.png"),
          ),

          // este endentamento permite rotação lateral.
          // Container.. Height / ListView.. ScrollDirection
          Container(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Row(
                  children: [
                    _FeatureItem(
                      'Transferencias',
                      Icons.monetization_on,
                      onTapFeatureItem: () {
                        _showContactList(context);
                      },
                    ),
                    _FeatureItem(
                      'Transações Efetuadas',
                      Icons.description,
                      onTapFeatureItem: () {
                        _showTransferenciasEfetuadas(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showContactList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ContactsList();
        },
      ),
    );
  }

  void _showTransferenciasEfetuadas(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return TransactionsList();
        },
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String _labelnome;
  final IconData _iconData;

  final Function onTapFeatureItem;

  const _FeatureItem(
    this._labelnome,
    this._iconData, {
    @required required this.onTapFeatureItem,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      // Envolver o Widget com funções de animaçao
      child: Material(
        // Neste caso o Material determina as cores
        color: Theme.of(context).primaryColor,

        // Envolver o Widget com funções de click
        child: InkWell(
          // Rota de navegação para a próxima página
          onTap: () {
            onTapFeatureItem();
          },
          child: Container(
            // Padding interno do container
            padding: EdgeInsets.all(8.0),
            height: 130,
            width: 130,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  _iconData,
                  color: Colors.white,
                  size: 24.0,
                ),
                Text(
                  _labelnome,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
