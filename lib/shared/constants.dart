import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app/shared/extension.dart';

import '../models/service.dart';
import '../models/user.dart';

class AppColors{
  static Color themeColor = const Color(0xff8f94fb);
}
enum UserProf {doctor, user}

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  border: InputBorder.none,
  hintStyle: TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  ),
);

const textStyleForQuestionAndAnswer = TextStyle(
    fontSize: 13,
    fontFamily: 'Public Sans',
    color: Colors.black
);

double height(context) {
  var myHeight = MediaQuery.of(context).size.height;
  return myHeight;
}

double width(context) {
  var myWidth = MediaQuery.of(context).size.width;
  return myWidth;
}

String getTimeDiff(DateTime dateTime){
  final duration = DateTime.now().difference(dateTime);
  if(duration.isNegative)
    return "0 sec ago";
  if(duration.inSeconds <= 60) {
    return duration.inSeconds > 1 ? "${duration.inSeconds} secs ago": "${duration.inSeconds} sec ago";
  } else if(duration.inMinutes <= 60) {
    return duration.inMinutes > 1 ? "${duration.inMinutes} mins ago": "${duration.inMinutes} min ago";
  } else if(duration.inHours <= 60){
    return duration.inHours > 1 ? "${duration.inHours} hours ago": "${duration.inHours} hour ago";
  } else if(duration.inDays <= 30) {
    return duration.inDays > 1 ? "${duration.inDays} days ago": "${duration.inDays} day ago";
  } else if(duration.inDays > 30 && duration.inDays <= 364) {
    return (duration.inDays/30).floor() > 1 ? "${(duration.inDays/30).floor()} months ago": "${(duration.inDays/30).floor()} month ago";
  } else {
    return (duration.inDays/365).floor() > 1 ? "${(duration.inDays/365).floor()} years ago": "${(duration.inDays/365).floor()} year ago";
  }
}

Widget customButton(String buttonName, Function function, double width){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 2.0),
    child: Container(
      height: 50.0,
      width: width,
      decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color.fromRGBO(143, 148, 251, 1),Color.fromRGBO(143, 148, 251, 0.5)]
          ),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(143, 148, 251, 0.5),
                blurRadius: 20.0,
                offset: Offset(0, 7)
            ),
          ]
      ),
      child: MaterialButton(
        child:  Text(
          buttonName,
          style: const TextStyle(color: Colors.white),
        ),
        color: Colors.transparent,
        elevation: 0.0,
        highlightElevation: 0.0,
        splashColor: Colors.transparent,
        highlightColor: const Color.fromRGBO(143, 148, 251, 1),
        height: 50.0,
        minWidth: 320.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        onPressed: () async{
          await function();
        }
      ),
    ),
  );
}


Widget customTile(User user, Services services, BuildContext context, Function function, bool showArrow) {
  return InkWell(
    onTap: () async{
      function(user, services);
    },
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    child: Container(
      height: MediaQuery.of(context).size.height*0.18,
      width: MediaQuery.of(context).size.width*0.6,
      margin: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
      decoration: BoxDecoration(
          color: Colors.red,
          boxShadow: [
            BoxShadow(
                color: AppColors.themeColor,
                blurRadius: 15.0,
                offset: const Offset(0, 5),
                spreadRadius: 1.0
            )
          ],
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
              colors: [Color.fromRGBO(143, 148, 251, 1),Color.fromRGBO(143, 148, 251, 0.5)],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft
          )
      ),
      child: Stack(
        children: <Widget>[
          SizedBox(
            //color: Colors.red,
            height: MediaQuery.of(context).size.height*0.18,
            width: MediaQuery.of(context).size.width*0.85,
            child: Stack(
              children: [
                Positioned(
                  left: 85,
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.30,
                    width: MediaQuery.of(context).size.width*0.55,
                    decoration: const BoxDecoration(
                        color: Colors.white12,
                        shape: BoxShape.circle
                    ),
                  ),
                ),
                if(showArrow)...[
                  const Positioned(
                      right: 5,
                      top: 55,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 25,
                      )
                  ),
                ],
                Positioned(
                  right: 120,
                  bottom: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.20,
                    width: MediaQuery.of(context).size.width*0.55,
                    decoration: const BoxDecoration(
                        color: Colors.white12,
                        shape: BoxShape.circle
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Text(
                    services.serviceLocation.capitalize(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical:18.0, horizontal: 15.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        services.serviceName,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    SizedBox(
                      // height: height(context)*0.1,
                      width: width(context)*0.7,
                      // color: Colors.red,
                      child: Text(
                        services.serviceDescription,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  ],
                )
            ),
          ),
        ],
      ),
    ),
  );
}

Future<bool> backPressed(context) async{
  return (await showDialog(
      context: context,
      builder: (context)=> AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)
        ),
        title: const Text(
          "Do you really want to exit?",
          style: TextStyle(
              fontSize: 15.0
          ),
        ),
        actions: <Widget>[
          MaterialButton(
            shape: StadiumBorder(),
            elevation: 1.0,
            color: Colors.white,
            child: Text(
              "Yes",
              style: TextStyle(
                  color: AppColors.themeColor,
                  fontSize: 12
              ),
            ),
            splashColor: AppColors.themeColor.withOpacity(0.3),
            highlightColor: Colors.transparent,
            onPressed: () {
              Navigator.pop(context,true);
            },
          ),
          MaterialButton(
            shape: StadiumBorder(),
            elevation: 3.0,
            color: Colors.white,
            child: Text(
              "No",
              style: TextStyle(
                  color: AppColors.themeColor,
                  fontSize: 12
              ),
            ),
            splashColor: AppColors.themeColor.withOpacity(0.3),
            highlightColor: Colors.transparent,
            onPressed: () {
              Navigator.pop(context,false);
            },
          ),
        ],
      )
  ))??false;
}