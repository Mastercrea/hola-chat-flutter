import 'package:flutter/material.dart';

import '../app_theme.dart';

class BtnBlue extends StatelessWidget {
  final Function()? onPressed;
  final String btnName;

  const BtnBlue({Key? key,  required this.btnName, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: this.onPressed,
      style: ElevatedButton.styleFrom(elevation: 2, primary: AppTheme.tertiaryColor, shape: StadiumBorder(), shadowColor: AppTheme.secondaryColor),
      child: Container(
          width: double.infinity,
          height: 55,
          child: Center(
            child: Text(this.btnName, style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 17))
          )
      ),
    );
  }
}
