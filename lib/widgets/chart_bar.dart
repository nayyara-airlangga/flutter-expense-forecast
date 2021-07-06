import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  const ChartBar({
    Key key,
    this.label,
    this.spendingAmount,
    this.spendingPctOfTotal,
  }) : super(key: key);

  final String label;
  final double spendingAmount;
  final double spendingPctOfTotal;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: <Widget>[
          Container(
            height: constraints.maxHeight * 0.15,
            child: FittedBox(
              child: Text(
                '\$${spendingAmount < 10 && spendingAmount > 0 ? spendingAmount.toStringAsFixed(2) : spendingAmount < 100 && spendingAmount > 0 ? spendingAmount.toStringAsFixed(1) : spendingAmount.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          ),
          SizedBox(height: constraints.maxHeight * 0.05),
          Container(
            height: constraints.maxHeight * 0.6,
            width: 10,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: spendingPctOfTotal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: constraints.maxHeight * 0.05),
          Container(
            height: constraints.maxHeight * 0.15,
            child: FittedBox(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
