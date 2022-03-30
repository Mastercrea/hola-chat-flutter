import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

showAlert(BuildContext context, String title, String subtitle) {
  if (Platform.isAndroid) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(title),
              content: Text(subtitle),
              actions: <Widget>[
                MaterialButton(
                    onPressed: () => Navigator.pop(context),
                    elevation: 5,
                    child: Text('Ok'),
                    textColor: Colors.blue)
              ],
            )
    );
  } else {
    showCupertinoDialog(context: context, builder: (_) =>
        CupertinoAlertDialog(
          title: Text(title),
          content: Text(subtitle),
          actions: [
            CupertinoDialogAction(
            isDefaultAction: true,
                child: Text('ok'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        )
    );
  }
}
