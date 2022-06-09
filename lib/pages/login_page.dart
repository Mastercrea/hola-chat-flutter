import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helpers/show_alert.dart';
import 'package:flutter_chat_app/services/socket_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:flutter_chat_app/widgets/btn_blue.dart';
import 'package:flutter_chat_app/widgets/custom_input.dart';
import 'package:flutter_chat_app/widgets/labels.dart';

import '../app_theme.dart';
import '../widgets/logo.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.primaryColor,
        // SingleChildScrollView best ui
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            // Special height for not break the app
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Logo(title: 'Messenger'),
                _Form(),
                Labels(routeNav: 'register',question: 'Don`t have an account?', action: 'Create one now!'),
                Text(
                  'Terms Of Use Agreement',
                  style: TextStyle(fontWeight: FontWeight.w200),
                )
              ],
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    return Container(
      // for better L&F
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          CustomInput(icon: Icons.mail_outline,
              placeholder: 'Email',
              keyboardType: TextInputType.emailAddress,
              textController: emailCtrl),
          CustomInput(icon: Icons.lock_outline,
              placeholder: 'Password',
              textController: passwordCtrl,
              isPassword: true),

          BtnBlue(onPressed: authService.authenticating ?  null : () async {
            // Hide the keyboard
            FocusScope.of(context).unfocus();

           final loginOk = await authService.login(emailCtrl.text.trim(), passwordCtrl.text.trim());
           if(loginOk){

             socketService.connect();
             Navigator.pushReplacementNamed(context, 'drawer');

           } else {
             // TODO: Show Alert error
             showAlert(context, 'Bad credentials', 'Check the data');
           }
          }, btnName: 'Login',)

        ],
      ),
    );
  }
}


