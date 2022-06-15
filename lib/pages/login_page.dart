import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helpers/show_alert.dart';
import 'package:flutter_chat_app/services/socket_service.dart';
import 'package:flutter_chat_app/widgets/loading_animation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:flutter_chat_app/widgets/btn_blue.dart';
import 'package:flutter_chat_app/widgets/custom_input.dart';
import 'package:flutter_chat_app/widgets/labels.dart';

import '../app_theme.dart';
import '../widgets/logo.dart';

var loadingFlag = false;

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

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
            height: MediaQuery.of(context).size.height * 0.9,
            child: Stack(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[
                  Logo(title: 'Messenger'),
                  _Form(),
                  Labels(
                      routeNav: 'register',
                      question: 'Don`t have an account?',
                      action: 'Create one now!'),
                  Text(
                    'Terms Of Use Agreement',
                    style: TextStyle(fontWeight: FontWeight.w200),
                  )
                ],
              ),
              authService.isLoading
                  ? const LoadingAnimation()
                  : Container(),
            ]),
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
          CustomInput(
              icon: Icons.mail_outline,
              placeholder: 'Email',
              keyboardType: TextInputType.emailAddress,
              textController: emailCtrl),
          CustomInput(
              icon: Icons.lock_outline,
              placeholder: 'Password',
              textController: passwordCtrl,
              isPassword: true),
          BtnBlue(
            onPressed: authService.isLoading
                ? null
                : () async {
                    // Hide the keyboard
                    FocusScope.of(context).unfocus();
                    loadingFlag = true;
                    final loginOk = await authService.login(
                        emailCtrl.text.trim(), passwordCtrl.text.trim());
                    loadingFlag = false;
                    if (loginOk) {
                      socketService.connect();
                      Navigator.pushReplacementNamed(context, 'drawer');
                    } else {
                      // TODO: Show Alert error
                      showAlert(context, 'Bad credentials', 'Check the data');
                    }
                  },
            btnName: 'Login',
          ),
          SizedBox(height: 10),
          MaterialButton(
              splashColor: Colors.transparent,
              minWidth: double.infinity,
              height: 40,
              color: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      FontAwesomeIcons.google,
                      color: Colors.white,
                    ),
                    Text('   Sign in with Google',
                        style: TextStyle(color: Colors.white, fontSize: 17)),
                  ]),
              onPressed: authService.isLoading
                  ? null
                  : () async => {
                        await authService.signInWithGoogle().then((value) => {
                              if (value)
                                {
                                  socketService.connect(),
                                  Navigator.pushReplacementNamed(
                                      context, 'drawer')
                                }
                              else
                                {
                                  showAlert(context, 'Bad credentials',
                                      'Check the data')
                                }
                            })
                      })
        ],
      ),
    );
  }
}
