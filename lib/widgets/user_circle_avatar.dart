import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../models/user.dart';

class UserCircleAvatar extends StatelessWidget {
  final User user;

  const UserCircleAvatar({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String lowResImg;
    if (user.img != null && Uri.parse(user.img!).isAbsolute) {
      if (user.img!.contains('cloudinary')) {
        lowResImg = user.img!.substring(0, 50) +
            'c_scale,h_100,w_100/' +
            user.img!.substring(50);
      } else {
        lowResImg = user.img!;
      }
      return CircleAvatar(
        backgroundImage: NetworkImage(lowResImg),
        backgroundColor: AppTheme.tertiaryColor,
      );
    } else {
      return CircleAvatar(
        child: Text(
          user.name.substring(0, 2),
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppTheme.tertiaryColor,
      );
    }
  }
}
