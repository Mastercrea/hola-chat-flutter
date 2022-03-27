import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/btn_blue.dart';
import 'package:flutter_chat_app/widgets/custom_input.dart';
import 'package:flutter_chat_app/widgets/labels.dart';

import '../widgets/logo.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF2F2F2),
        // SingleChildScrollView best ui
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            // Special height for not break the app
            height: MediaQuery.of(context).size.height * 0.95,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Logo(title: 'Register'),
                _Form(),
                 Labels(routeNav: 'login',question: 'Has an account?', action: 'Log in'),
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
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      // for better L&F
      margin: EdgeInsets.only(top: 40),
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

          BtnBlue(onPressed: (){
            print(nameCtrl.text);
            print(emailCtrl.text);
            print(passwordCtrl.text);
          }, btnName: 'Register',)

        ],
      ),
    );
  }
}


