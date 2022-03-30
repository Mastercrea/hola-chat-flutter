import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/login_page.dart';
import 'package:flutter_chat_app/pages/users_page.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
      future: checkLoginState(context),
        builder: (context, snapshot) {
          return Center(
            child: Text('Please Wait...'),
          );
        },
      ),
    );
  }
  Future checkLoginState(BuildContext context) async{
    final authService = Provider.of<AuthService>(context, listen: false);
    final authenticated = await authService.isLoggedIn();
    if(authenticated) {
      // TODO: Connect to socket server
      // Navigator.pushReplacementNamed(context, 'users');
      // Routes with animations
      Navigator.pushReplacement(context,
          PageRouteBuilder(
              pageBuilder: ( _, __ , ___) => UsersPage(),
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
