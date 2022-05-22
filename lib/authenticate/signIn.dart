import 'package:flutter/material.dart';
import 'package:health_app/pages/doctor/doctorHomePage.dart';
import 'package:health_app/pages/user/userHomePage.dart';
import '../models/user.dart';
import '../service/sqlDatabase.dart';
import '../shared/constants.dart';
import '../shared/customRoute.dart';
import '../shared/helperFunctions.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({Key? key, required this.toggleView}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}
class _SignInState extends State<SignIn> {

  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String errorMessage="";


  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                height: height(context)*0.5,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/background.png"),
                    fit: BoxFit.cover,
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: <Widget>[
                      Align(
                        child: Image.asset("assets/images/on.png"),
                        alignment: Alignment.topLeft,
                      ),
                      Expanded(
                        child: Align(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Icon(
                                Icons.account_circle,
                                size: 150.0,
                                color: Color.fromRGBO(143, 148, 255, 1),
                              ),
                              Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 45.0,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                        ),
                      ),
                      Align(
                        child: Image.asset("assets/images/off.png"),
                        alignment: Alignment.topRight,
                      )
                    ],
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: const Border(),
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromRGBO(143, 148, 251, 0.5),
                                blurRadius: 20.0,
                                offset: Offset(0, 10)
                            )
                          ]
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: textInputDecoration.copyWith(
                                hintText: "Email",
                              ),
                              validator: (val) => (val==null||val.isEmpty) ? 'Enter an email' : null,
                              controller: emailEditingController,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            child: TextFormField(
                              decoration: textInputDecoration.copyWith(
                                hintText: "Password",
                              ),
                              obscureText: true,
                              validator: (val) => (val==null||val.isEmpty) ?'Enter a password' : val.length < 6 ? 'Enter a password 6+ chars long' : null,
                              controller: passwordEditingController,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50.0,),
                  customButton("Login", loginButton, width(context)*0.82),
                  const SizedBox(height: 10.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "New Account?",
                        style: TextStyle(
                            color: Colors.grey
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          widget.toggleView();
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                              color: Color.fromRGBO(143, 148, 251, 1)
                          ),
                        ),
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0,),
                  Text(
                    errorMessage,
                    style: TextStyle(
                        color: Colors.red[200]
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loginButton() async{
    if(_formKey.currentState!.validate()){
      var user = User("null",emailEditingController.text, "null", passwordEditingController.text, "null");
      User? userReturn = User("null","null","null","null", "null");

      var db = DatabaseHelper();
      userReturn = await db.selectUser(user);

      if(userReturn != null){
        // Future.value(User("null", username, password));
        // print("\n\n userName: ${userReturn.userName}\n\n");
        // print("\n\n userEmail: ${userReturn.userEmail}\n\n");
        // print("\n\n isDoctor: ${userReturn.isDoctor}\n\n");

        HelperFunctions.saveUserLoggedInSharedPreference(true);
        HelperFunctions.saveUserEmailSharedPreference(userReturn.userEmail);
        HelperFunctions.saveUserNameSharedPreference(userReturn.userName);
        HelperFunctions.saveIsDoctorSharedPreference(userReturn.isDoctor ==  "true" ? true: false);

        print("\n\n userName: ${userReturn.userName}\n\n");
        print("\n\n userEmail: ${userReturn.userEmail}\n\n");

        if(userReturn.isDoctor ==  "true"){
          Navigator.of(context).pushReplacement(CustomRoute(page: DoctorHomePage(user: userReturn)));
        }else{
          Navigator.of(context).pushReplacement(CustomRoute(page: UserHomePage(user: userReturn)));
        }

      }else {
        setState(() {
          errorMessage = "Invalid Email Or Password";
        });
      }
    }
  }

}
