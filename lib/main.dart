import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'widgets/new_transaction.dart';
import 'widgets/transaction_list.dart';
import 'widgets/chart.dart';
import 'models/transaction.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Forecast',
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        fontFamily: 'Karla',
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              button: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 14,
                fontWeight: FontWeight.w100,
                color: Colors.white,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: Theme.of(context).textTheme.headline6.fontSize,
                  fontWeight: FontWeight.w100,
                ),
              ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransactions = [];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((transaction) {
      return transaction.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  bool _showChart = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _addNewTransactions({
    String transactionTitle,
    double transactionAmount,
    DateTime selectedDate,
  }) {
    final newTransaction = Transaction(
      id: DateTime.now().toString(),
      amount: transactionAmount,
      date: selectedDate,
      title: transactionTitle,
    );
    setState(() {
      _userTransactions.add(newTransaction);
    });
  }

  List<Widget> _buildLandscapeContent({
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget transactionList,
  }) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Platform.isIOS
              ? CupertinoSwitch(
                  value: _showChart,
                  activeColor: Theme.of(context).accentColor,
                  onChanged: (value) {
                    setState(() {
                      _showChart = value;
                    });
                  },
                )
              : Switch(
                  value: _showChart,
                  onChanged: (value) {
                    setState(() {
                      _showChart = value;
                    });
                  },
                ),
        ],
      ),
      _showChart
          ? Platform.isIOS
              ? Container(
                  height: (mediaQuery.size.height -
                          appBar.preferredSize.height -
                          mediaQuery.padding.top) *
                      0.7,
                  child: Chart(
                    recentTransactions: _recentTransactions,
                  ),
                )
              : Container(
                  height: (mediaQuery.size.height -
                          appBar.preferredSize.height -
                          mediaQuery.padding.top) *
                      0.62,
                  child: Chart(
                    recentTransactions: _recentTransactions,
                  ),
                )
          : transactionList,
    ];
  }

  List<Widget> _buildPortraitContent({
    MediaQueryData mediaQuery,
    PreferredSizeWidget appBar,
    Widget transactionList,
  }) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.35,
        child: Chart(recentTransactions: _recentTransactions),
      ),
      transactionList,
    ];
  }

  PreferredSizeWidget _buildAdaptiveAppBar() {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            automaticallyImplyLeading: true,
            middle: Text(
              'Expense Forecast',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: () => _startAddNewTransaction(context),
                  child: Icon(
                    CupertinoIcons.add,
                    size: 24,
                  ),
                ),
              ],
            ),
          )
        : AppBar(
            title: Text('Expense Forecast'),
            actions: <Widget>[
              IconButton(
                onPressed: () => _startAddNewTransaction(context),
                icon: Icon(Icons.add),
              ),
            ],
          );
  }

  void _startAddNewTransaction(BuildContext context) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (_) {
        return NewTransaction(
          addTransaction: _addNewTransactions,
        );
      },
    );
  }

  void _deleteTransaction({String id}) {
    setState(() {
      _userTransactions.removeWhere((transaction) => transaction.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final bool isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = _buildAdaptiveAppBar();
    final Widget transactionList = Container(
      height: isLandscape
          ? (mediaQuery.size.height -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) *
              0.63
          : (mediaQuery.size.height -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) *
              0.61,
      child: TransactionList(
        transactions: _userTransactions,
        deleteTransaction: _deleteTransaction,
      ),
    );

    final Widget pageBody = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (isLandscape)
            ..._buildLandscapeContent(
              mediaQuery: mediaQuery,
              appBar: appBar,
              transactionList: transactionList,
            ),
          if (!isLandscape)
            ..._buildPortraitContent(
              mediaQuery: mediaQuery,
              appBar: appBar,
              transactionList: transactionList,
            ),
        ],
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: const Icon(
                      Icons.add,
                    ),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
