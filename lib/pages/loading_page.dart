import 'package:flutter/material.dart';
import 'package:flutter_chat_app/app_theme.dart';
import 'package:flutter_chat_app/navigation_home_screen.dart';
import 'package:flutter_chat_app/pages/login_page.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:flutter_chat_app/services/socket_service.dart';
import 'package:provider/provider.dart';

import '../widgets/loading_animation.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}


class _LoadingPageState extends State<LoadingPage> {
  late Future _futureCheckLoginState;

  @override
  void initState() {
    _futureCheckLoginState = checkLoginState(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppTheme.primaryColor,
      body: FutureBuilder(
      future: _futureCheckLoginState,
        builder: (context, snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Please Wait', style: TextStyle(color: Colors.white, fontSize: 20)),
              LoadingAnimation(),
            ]
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async{
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);
    final authenticated = await authService.isLoggedIn();
    if(authenticated) {
      socketService.connect();
      // Navigator.pushReplacementNamed(context, 'users');
      // Routes with animations
      Navigator.pushReplacement(context,
          PageRouteBuilder(
              pageBuilder: ( _, __ , ___) => NavigationHomeScreen(),
            transitionDuration: Duration(milliseconds: 1000)
          )
      );
    } else {
      Navigator.pushReplacement(context,
          PageRouteBuilder(
              pageBuilder: ( _, __ , ___) => LoginPage(),
              transitionDuration: Duration(milliseconds: 1000)
          )
      );
    }
  }
}

