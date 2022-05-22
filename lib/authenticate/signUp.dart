import 'package:flutter/material.dart';
import '../models/user.dart';
import '../pages/doctor/doctorHomePage.dart';
import '../pages/user/userHomePage.dart';
import '../service/sqlDatabase.dart';
import '../shared/constants.dart';
import '../shared/customRoute.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({Key? key, required this.toggleView}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}
class _RegisterState extends State<Register> {

  final _formKey = GlobalKey<FormState>();
  UserProf userType = UserProf.user;

  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController usernameEditingController = TextEditingController();

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
                                "SignUp",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 45.0,
                                    fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          ),
                          alignment: Alignment.center,
                        ),
                      ),
                      Align(
                        child: Image.asset("assets/images/off.png"),
                        alignment: Alignment.topRight,
                      ),
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
                              decoration: textInputDecoration.copyWith(
                                hintText: "Name",
                              ),
                              validator: (val) => (val==null||val.isEmpty) ? 'Enter an name' : null,
                              controller: usernameEditingController,
                            ),
                          ),
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
                              validator: (val) => (val==null||val.length < 6 ) ? 'Enter a password 6+ chars long' : null,
                              controller: passwordEditingController,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
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
                      child: Row(
                        children: [
                          const Text(
                            "Are You A Doctor?",
                            style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                          Spacer(),
                          Row(
                            children: [
                              const Text(
                                "Yes",
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                              Radio(
                                activeColor: AppColors.themeColor,
                                value: UserProf.doctor,
                                groupValue: userType,
                                onChanged: (UserProf? value) {
                                  setState(() {
                                    userType = value!;
                                  });
                                },
                              ),
                              const Text(
                                "No",
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                              Radio(
                                activeColor: AppColors.themeColor,
                                value: UserProf.user,
                                groupValue: userType,
                                onChanged: (UserProf? value) {
                                  setState(() {
                                    userType = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50.0,),
                  customButton("SignUp", registerButton, width(context)*0.82),
                  const SizedBox(height:5.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Account Already?",
                        style: TextStyle(
                            color: Colors.grey
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          widget.toggleView();
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              color: Color.fromRGBO(143, 148, 251, 1)
                          ),
                        ),
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  void registerButton() async{
    if(_formKey.currentState!.validate()){
      String userProf = "false";
      if(userType.name == "doctor"){
        userProf = "true";
      }else{
        userProf = "false";
      }
      DateTime time = DateTime.now();
      var user = User(time.microsecondsSinceEpoch.toString(), emailEditingController.text, usernameEditingController.text, passwordEditingController.text, userProf);
      setState(() {
        var db = DatabaseHelper();
        db.saveUser(user);
      });
      if(userProf ==  "true"){
        Navigator.of(context).pushReplacement(CustomRoute(page: DoctorHomePage(user: user)));
      }else{
        Navigator.of(context).pushReplacement(CustomRoute(page: UserHomePage(user: user)));
      }
    }
  }


}