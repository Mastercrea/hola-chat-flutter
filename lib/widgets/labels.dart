import 'package:flutter/material.dart';

class Labels extends StatelessWidget {

  final String routeNav;
  final String question;
  final String action;

  const Labels({Key? key, required this.routeNav, required this.question, required this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        Text(this.question,
            style: TextStyle(
                color: Colors.black54,
                fontSize: 15,
                fontWeight: FontWeight.w300)),
        const SizedBox(height: 10),
        GestureDetector(
          child: Text(
            this.action,
            style: TextStyle(
                color: Colors.blue[600],
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),onTap: (){
            Navigator.pushReplacementNamed(context, this.routeNav);
            print('tap');
        },
        )
      ]),
    );
  }
}