import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.deleteTransaction,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTransaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: FittedBox(
              child: Text(
                '\$${transaction.amount.toStringAsFixed(0).length >= 4 ? transaction.amount.toStringAsFixed(0) : transaction.amount.toStringAsFixed(1).length >= 5 ? transaction.amount.toStringAsFixed(1) : transaction.amount.toStringAsFixed(2).length == 4 ? transaction.amount.toStringAsFixed(2) : transaction.amount.toStringAsFixed(2).length < 4 ? transaction.amount.toStringAsFixed(2) : transaction.amount.toStringAsFixed(2)}',
              ),
            ),
          ),
        ),
        title: Text(
          transaction.title,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        subtitle: Text(
          DateFormat('EEEEE, dd MMMM yyyy').format(transaction.date),
          style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Colors.grey,
                fontSize: 14,
              ),
        ),
        trailing: MediaQuery.of(context).orientation == Orientation.landscape
            ? TextButton.icon(
                onPressed: () => deleteTransaction(id: transaction.id),
                icon: const Icon(
                  Icons.delete,
                  // color: Theme.of(context).errorColor,
                ),
                label: const Text('Delete'),
              )
            : IconButton(
                icon: const Icon(
                  Icons.delete,
                ),
                color: Theme.of(context).errorColor,
                onPressed: () => deleteTransaction(id: transaction.id),
              ),
      ),
    );
  }
}
