import 'package:flutter/foundation.dart';

class Transaction {
  @required final String id;//unique id that identifies transaction
  @required final String title;//o ćemu se govori, na što je potrošeno
  @required final double amount;
  @required final DateTime date;

  Transaction({this.id, this.title,this.amount, this.date});
}