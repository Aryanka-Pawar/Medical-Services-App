import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_app/pages/doctor/doctorHomePage.dart';
import 'package:health_app/pages/user/userHomePage.dart';
import 'package:health_app/shared/constants.dart';
import 'package:health_app/shared/customRoute.dart';
import 'package:health_app/shared/helperFunctions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'authenticate/auth.dart';
import 'models/user.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool isLoggedIn = false;
  bool isDoctor = false;
  String userName = "null";
  String userEmail = "null";
  int userId = 0;

  welcomePage() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool(HelperFunctions.sharedPreferenceUserLoggedInKey) ?? false;
      isDoctor = prefs.getBool(HelperFunctions.sharedPreferenceIsDoctorKey) ?? false;
      userId = prefs.getInt(HelperFunctions.sharedPreferenceUserIdKey) ?? 0;
      userEmail = prefs.getString(HelperFunctions.sharedPreferenceUserEmailKey) ?? "null";
      userName = prefs.getString(HelperFunctions.sharedPreferenceUserNameKey) ?? "null";
    });
    Timer(const Duration(seconds: 1), () {
      if(isLoggedIn){
        var user = User(userId.toString(), userEmail, userName, "null", isDoctor.toString());
        Navigator.of(context).pushReplacement(CustomRoute(page: isDoctor==true? DoctorHomePage(user: user,) : UserHomePage(user:user)));
      }else{
        Navigator.of(context).pushReplacement(CustomRoute(page: const Authenticate()));
      }
    });
  }


  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
    ));
    welcomePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text("Splash Screen", style: TextStyle(color: AppColors.themeColor, fontSize: 30))
      ),
    );
  }
}