import 'package:flutter/material.dart';

import '../models/transaction.dart';
import 'transaction_item.dart';

class TransactionList extends StatelessWidget {
  TransactionList({
    Key key,
    this.transactions,
    this.deleteTransaction,
  }) : super(key: key);

  final List<Transaction> transactions;
  final Function deleteTransaction;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final Orientation landscape = Orientation.landscape;
    return transactions.isEmpty
        ? LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: <Widget>[
                SizedBox(
                  height: mediaQuery.orientation == landscape
                      ? constraints.maxHeight * 0.14
                      : constraints.maxHeight * 0.13,
                ),
                Container(
                  height: mediaQuery.orientation == landscape
                      ? constraints.maxHeight * 0.12
                      : constraints.maxHeight * 0.1,
                  width: mediaQuery.orientation == landscape
                      ? constraints.maxWidth * 0.8
                      : constraints.maxWidth * 0.7,
                  child: FittedBox(
                    child: Text(
                      'No transactions added yet...',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
                SizedBox(
                    height: mediaQuery.orientation == landscape
                        ? constraints.maxHeight * 0.1
                        : constraints.maxHeight * 0.05),
                Container(
                  height: mediaQuery.orientation == landscape
                      ? constraints.maxHeight * 0.55
                      : constraints.maxHeight * 0.35,
                  child: FittedBox(
                      child: Image.asset('assets/images/waiting.png')),
                ),
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (context, index) {
              return TransactionItem(
                transaction: transactions[index],
                deleteTransaction: deleteTransaction,
              );
            },
            itemCount: transactions.length,
          );
  }
}
