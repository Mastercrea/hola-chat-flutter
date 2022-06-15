import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../app_theme.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Container(
      color: Colors.transparent,
      child: Center(
        child: LoadingAnimationWidget.prograssiveDots(
          color: AppTheme.secondaryColor,
          size: 50,
        ),
      ),
    );
  }
}
class LoadingPicture extends StatelessWidget {
  const LoadingPicture({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: LoadingAnimationWidget.hexagonDots(
          color: AppTheme.secondaryColor,
          size: 50,
        ),
      ),
    );
  }
}
