import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions; //incoming transaction are saved here
  final Function deleteTx;

  TransactionList(
      this.transactions, this.deleteTx); //konstruktor služi for passing data from parent to child

  @override
  Widget build(BuildContext context) {
    //stavimo output liste transakcija tu
    return Container(
      height: 500,
      child: transactions.isEmpty
          ? Column(
              children: <Widget>[
                Text(
                  'Your list is kinda empty, huh?',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 20,),
                Container(
                  height: 200,
                    child: Image.asset(
                  'assets/images/waiting.png',
                  fit: BoxFit.cover,
                )),
              ],
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                //must have argument koji takea funkciju s argumentima(context, int)
                //context - automatski od fluttera, index- index itema koji trenutno buildamo.
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text('${transactions[index].amount}kn')),
                      ),
                    ),
                    title: Text(
                        transactions[index].title,
                        style: Theme.of(context).textTheme.headline6,
                    ),
                    subtitle: Text(
                      DateFormat('dd.MM.yyyy.').format(transactions[index].date),
                    ),
                    trailing: IconButton(icon: Icon(Icons.delete),
                        color: Theme.of(context).errorColor,
                        onPressed:() => deleteTx(transactions[index].id) ),//widget on the end of the list Tile

                  ),
                );
              },
              itemCount: transactions.length, //koliko itema se treba buildati
            ),
    );
  }
}
