import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx; //2. i taj pointter bindamo u addTx var.

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;//has no value until user chose the date

  void _submitData() {
    //funkcija za sumbit data kada upišemo amount i title
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);
    if (enteredTitle.isEmpty || enteredAmount <= 0 ||_selectedDate == null) {
      return;
    }

    widget.addTx(
      //we can access the properties and mehods of your widget class instead of your state class
      enteredTitle,
      //accessamo iz gornjeg widgeta addTx propertyu iako su tehnički u drugoj klasi.
      enteredAmount, //widget. je samo available u state class
      _selectedDate,
    );
    Navigator.of(context)
        .pop(); //closing topmost screen that is displayed(modal sheet)
  }

  void _presentDatePicker() {
    showDatePicker(
        //flutterova funkcija date pickera s 4 argumenta
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019),
        lastDate: DateTime.now(),
    ).then((value) {
      if(value==null){//user pressed cancel
        return;//ne vratimo ništa i prekine se izvođenje daljneg koda
      }
      setState(() {//telling flutter that stful widget updated i build treba runnati
        _selectedDate = value;//prosli smo uvijet onda znaci da je odabran date i spremamo ga u var.
      });


    });

  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        child: Container(
          //radi uređivanje paddinga oko columna i textfielda
          padding: EdgeInsets.all(10),
          child: Column(
              //
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Title'),
                  controller: _titleController,
                  onSubmitted: (_) => _submitData(),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Amount'),
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) =>
                      _submitData(), //listener koji submita kad stisnemo done gumb na tipkovnici.
                ),
                Container(
                  height: 70,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(_selectedDate == null ? 'No Date Chosen'
                            :'Picked Date: ${DateFormat('dd.MM.yyyy').format(_selectedDate)}'),
                      ),
                      FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        child: Text(
                          'Choose Date',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: _presentDatePicker,
                      )
                    ],
                  ),
                ),
                RaisedButton(
                  child: Text('Add transaction'),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).textTheme.button.color,
                  onPressed: _submitData,
                )
                //widget for user input
              ]),
        ));
  }
}
