import 'package:flutter/material.dart';

class Logo extends StatelessWidget {

  final String title;

  const Logo({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SafeArea(
        child: Container(
          width: 170,
          margin: EdgeInsets.only(top: 50),
          child: Column(children:  <Widget>[
            Image(image: AssetImage('assets/logo5.png')),
            SizedBox(height: 20),
            Text(
              this.title,
              style: TextStyle(fontSize: 30,
                  fontFamily: 'blogger',
                  fontWeight: FontWeight. bold,
                  color: Colors.white),
            )
          ]),
        ),
      ),
    );
  }
}