import 'package:flutter/material.dart';
import 'package:health_app/authenticate/signIn.dart';
import 'package:health_app/authenticate/signUp.dart';


class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}
class _AuthenticateState extends State<Authenticate> {
  bool showSignIn=true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showSignIn==true){
      return SignIn(toggleView : toggleView);
    }
    else{
      return Register(toggleView : toggleView);
    }
  }
}