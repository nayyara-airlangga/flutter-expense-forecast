import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {
  NewTransaction({
    Key key,
    this.addTransaction,
  }) : super(key: key);

  final Function addTransaction;

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 7)),
    ).then((selectedDate) {
      if (selectedDate == null) {
        setState(() {
          _selectedDate = selectedDate;
        });
      }

      setState(() {
        _selectedDate = selectedDate;
      });
    });
  }

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }

    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTransaction(
      transactionTitle: enteredTitle,
      transactionAmount: enteredAmount,
      selectedDate: _selectedDate,
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: Theme.of(context)
                      .appBarTheme
                      .textTheme
                      .headline6
                      .copyWith(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                  //TextStyle(color: Theme.of(context).primaryColor),
                ),
                cursorColor: Theme.of(context).primaryColor,
                controller: _titleController,
                onSubmitted: (_) {
                  setState(() {
                    _selectedDate = DateTime.now();
                  });
                  _submitData();
                },
                //onChanged: (value) => titleInput = value,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Amount',
                  labelStyle: Theme.of(context)
                      .appBarTheme
                      .textTheme
                      .headline6
                      .copyWith(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                  //TextStyle(color: Theme.of(context).primaryColor),
                ),
                cursorColor: Theme.of(context).primaryColor,
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) {
                  setState(() {
                    _selectedDate = DateTime.now();
                  });
                  _submitData();
                },
                //onChanged: (value) => amountInput = value,
              ),
              Container(
                height: 45,
                child: Row(
                  children: <Widget>[
                    Text(
                      _selectedDate == null
                          ? 'Selected Date: Today'
                          : '${DateFormat('EEEE, dd MMMM yyyy').format(_selectedDate)}' ==
                                  DateFormat('EEEE, dd MMMM yyyy')
                                      .format(DateTime.now())
                              ? 'Selected Date: Today'
                              : 'Selected Date: ${DateFormat('EEEEE, dd MMMM yyyy').format(_selectedDate)}',
                      style: Theme.of(context)
                          .appBarTheme
                          .textTheme
                          .headline6
                          .copyWith(
                            fontSize: 14,
                          ),
                    ),
                    Spacer(),
                    AdaptiveFlatButton(
                      text: 'Choose Date',
                      handler: _showDatePicker,
                    ),
                  ],
                ),
              ),
              Platform.isIOS
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.all(20),
                          child: CupertinoButton(
                            color: Theme.of(context).primaryColor,
                            child: Text(
                              'Add Transaction',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedDate = DateTime.now();
                              });
                              _submitData();
                            },
                          ),
                        ),
                      ],
                    )
                  : ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedDate = DateTime.now();
                        });
                        _submitData();
                      },
                      child: Text(
                        'Add Transaction',
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
