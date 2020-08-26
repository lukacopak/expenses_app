import './widgets/chart.dart';

import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import 'package:flutter/material.dart';
import './models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
          primarySwatch: Colors.teal,
          accentColor: Colors.amberAccent,
          fontFamily: 'Quicksand',
          //errorColor: Colors.red, default
          textTheme: ThemeData.light().textTheme.copyWith(
                // ignore: deprecated_member_use
                title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
            button: TextStyle(color: Colors.white),
              ),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                    headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
          )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    /*Transaction(
      id: 'a1',
      title: 'Whey',
      amount: 20.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 'a2',
      title: 'Nicholas Cage Memorabilia',
      amount: 10.99,
      date: DateTime.now(),
    )*/
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime chosenDate) {
    //nova metoda koja je dio privatne klase _usertransactionState
    final newTx = Transaction(
      //final cuz of values u argumentima ^,a
      title: txTitle,
      //njih ne znamo at the point of writing the code(pa ne može biti const).
      amount: txAmount,
      //title, amount iz konstruktora u transaction.dart
      date: chosenDate,
      //trenutno nemamo DateTime picker pa koristimo current date
      id: DateTime.now()
          .toString(), //generira se autom i unique, inače se ne koristi, ali ovdje će poslužiti
    );
    setState(() {
      //za updateanje liste
      _userTransactions.add(
          newTx); //add new element i changea existing list, it wont generate new pointer/adress.
    }); //nema violation of final List,we just added object storen in final var.
  }

  void _startAddNewTransaction(BuildContext ctx) {
    //context dobijemo iz widget builda pa samo prihvatimo tu.
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {}, //do nothing when you tap on sheet, da se ne povuće.
            child: NewTransaction(
                _addNewTransaction), //widget koji želimo pokazati u modal sheet, to bi trebala bit newTransaction.
            //behavior: HitTestBehavior.opaque, //pošto trebamo methodu addTx, moramo cijelu logiku tu staviti i pretvoriti u stful widget
          );
        });
  }
  void _deleteTransaction(String id) {//preko id raspoznajemo transakciju koju želimo deletetati
    setState(() {
      _userTransactions.removeWhere((element) => element.id==id);//remove item where certain condition is met
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Expenses'),
        actions: <Widget>[
          IconButton(
            //renders a button that only holds an icon
            icon: Icon(Icons.add),
            onPressed: () => _startAddNewTransaction(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Chart(_recentTransactions),
            TransactionList(_userTransactions,_deleteTransaction),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
