import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveFlatButton extends StatelessWidget {
  const AdaptiveFlatButton({
    Key key,
    this.text,
    this.handler,
  }) : super(key: key);

  final Function handler;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Container(
            margin: EdgeInsets.only(top: 2),
            child: FittedBox(
              child: CupertinoButton(
                child: Text(
                  text,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: handler,
              ),
            ),
          )
        : TextButton(
            onPressed: handler,
            child: Text(
              text,
              style: Theme.of(context).appBarTheme.textTheme.headline6.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Theme.of(context).primaryColor,
                  ),
              //TextStyle(color: Theme.of(context).primaryColor),
            ),
          );
  }
}
