import 'package:flutter/material.dart';

import '../theme.dart';

class BtnBlue extends StatelessWidget {
  final Function()? onPressed;
  final String btnName;

  const BtnBlue({Key? key,  required this.btnName, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: this.onPressed,
      style: ElevatedButton.styleFrom(elevation: 2, primary: tertiaryColor, shape: StadiumBorder(), shadowColor: secondaryColor),
      child: Container(
          width: double.infinity,
          height: 55,
          child: Center(
            child: Text(this.btnName, style: TextStyle(color: textSecondaryColor, fontSize: 17))
          )
      ),
    );
  }
}
