import 'dart:io';

import 'package:flutter/material.dart';
import '../widgets/chart_bar.dart';
import 'package:intl/intl.dart';

import 'chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  const Chart({
    Key key,
    this.recentTransactions,
  }) : super(key: key);

  final List<Transaction> recentTransactions;

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().add(
        Duration(days: index),
      );

      double totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum,
      };
    });
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 6,
        margin: MediaQuery.of(context).orientation == Orientation.landscape
            ? Platform.isIOS
                ? EdgeInsets.only(left: 20, right: 20, top: 20)
                : EdgeInsets.symmetric(horizontal: 20)
            : EdgeInsets.all(20),
        child: LayoutBuilder(builder: (context, constraints) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: LayoutBuilder(builder: (context, constraints1) {
                return Column(
                  children: [
                    Container(
                      height: constraints1.maxHeight * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: groupedTransactionValues.map((data) {
                          return Flexible(
                            fit: FlexFit.tight,
                            child: ChartBar(
                              label: data['day'],
                              spendingAmount: data['amount'],
                              spendingPctOfTotal: totalSpending == 0
                                  ? 0.0
                                  : (data['amount'] as double) / totalSpending,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.05),
                    Container(
                      height: constraints1.maxHeight * 0.14,
                      child: FittedBox(
                        child: Text(
                          'Total (7 Days) : \$${totalSpending < 10 && totalSpending > 0 ? totalSpending.toStringAsFixed(2) : totalSpending < 100 && totalSpending > 0 ? totalSpending.toStringAsFixed(1) : totalSpending.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          );
        }),
      ),
    );
  }
}
