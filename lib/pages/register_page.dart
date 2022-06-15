import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:flutter_chat_app/services/socket_service.dart';
import 'package:flutter_chat_app/widgets/btn_blue.dart';
import 'package:flutter_chat_app/widgets/custom_input.dart';
import 'package:flutter_chat_app/widgets/labels.dart';
import 'package:provider/provider.dart';

import '../app_theme.dart';
import '../helpers/show_alert.dart';
import '../widgets/loading_animation.dart';
import '../widgets/logo.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
        backgroundColor: AppTheme.primaryColor,
        // SingleChildScrollView best ui
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            // Special height for not break the app
            height: MediaQuery.of(context).size.height * 0.95,
            child: Stack(
              children: [
                Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Logo(title: 'Register'),
                  _Form(),
                   Labels(routeNav: 'login',question: 'Already had an account?', action: 'Log in'),
                  Text(
                    'Terms Of Use Agreement',
                    style: TextStyle(fontWeight: FontWeight.w200),
                  )
                ],
              ),
                authService.isLoading
                    ? const LoadingAnimation()
                    : Container(),
              ]
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
  final nameCtrl = TextEditingController();
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
          CustomInput(icon: Icons.perm_identity,
              placeholder: 'Name',
              keyboardType: TextInputType.text,
              textController: nameCtrl),
          CustomInput(icon: Icons.mail_outline,
              placeholder: 'Email',
              keyboardType: TextInputType.emailAddress,
              textController: emailCtrl),
          CustomInput(icon: Icons.lock_outline,
              placeholder: 'Password',
              textController: passwordCtrl,
              isPassword: true),

          BtnBlue(onPressed: authService.isLoading ?  null : () async {
            print(nameCtrl.text);
            print(emailCtrl.text);
            print(passwordCtrl.text);
            final registerOk = await authService.register(nameCtrl.text.trim(), emailCtrl.text.trim(), passwordCtrl.text.trim());
            if(registerOk == true){
              socketService.connect();
              Navigator.pushReplacementNamed(context, 'drawer');

            } else {
              showAlert(context, 'Check the data', registerOk);
            }
          }, btnName: 'Register',)

        ],
      ),
    );
  }
}


