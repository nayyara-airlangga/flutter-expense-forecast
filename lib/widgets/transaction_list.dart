import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

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
              return Card(
                elevation: 6,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: FittedBox(
                        child: Text(
                          '\$${transactions[index].amount.toStringAsFixed(0).length >= 4 ? transactions[index].amount.toStringAsFixed(0) : transactions[index].amount.toStringAsFixed(1).length >= 5 ? transactions[index].amount.toStringAsFixed(1) : transactions[index].amount.toStringAsFixed(2).length == 4 ? transactions[index].amount.toStringAsFixed(2) : transactions[index].amount.toStringAsFixed(2).length < 4 ? transactions[index].amount.toStringAsFixed(2) : transactions[index].amount.toStringAsFixed(2)}',
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    transactions[index].title,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  subtitle: Text(
                    DateFormat('EEEEE, dd MMMM yyyy')
                        .format(transactions[index].date),
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                  ),
                  trailing: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? TextButton.icon(
                          onPressed: () =>
                              deleteTransaction(id: transactions[index].id),
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).errorColor,
                          ),
                          label: Text('Delete'),
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).errorColor,
                          ),
                          onPressed: () =>
                              deleteTransaction(id: transactions[index].id),
                        ),
                ),
              );
              // return Card(
              //   child: Row(
              //     children: <Widget>[
              //       Container(
              //         padding: EdgeInsets.all(10),
              //         margin: EdgeInsets.symmetric(
              //           vertical: 10,
              //           horizontal: 15,
              //         ),
              //         decoration: BoxDecoration(
              //           border: Border.all(
              //             color: Theme.of(context).primaryColor,
              //             width: 2,
              //           ),
              //         ),
              //         child: Text(
              //           '\$${transactions[index].amount.toStringAsFixed(2)}',
              //           style: TextStyle(
              //             fontWeight: FontWeight.bold,
              //             fontSize: 20,
              //             color: Theme.of(context).primaryColor,
              //           ),
              //         ),
              //       ),
              //       Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: <Widget>[
              //           Text(
              //             transactions[index].title,
              //             style: Theme.of(context).textTheme.bodyText1,
              //           ),
              //           Text(
              //             DateFormat('EEEEE, dd MMMM yyyy')
              //                 .format(transactions[index].date),
              //             style: TextStyle(
              //               color: Colors.grey,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // );
            },
            itemCount: transactions.length,
          );
  }
}
