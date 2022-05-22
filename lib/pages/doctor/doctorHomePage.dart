import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_app/pages/doctor/addService.dart';
import 'package:health_app/service/firebaseDatabase.dart';
import 'package:health_app/shared/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../authenticate/auth.dart';
import '../../models/service.dart';
import '../../models/user.dart';
import '../../shared/customRoute.dart';
import '../../shared/helperFunctions.dart';
import '../chat/chat_room.dart';

class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return backPressed(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Doctor Panel"),
          backgroundColor: AppColors.themeColor,
          actions: [
            IconButton(
              onPressed: () {
                HelperFunctions.saveUserLoggedInSharedPreference(false);
                Navigator.of(context).pushReplacement(CustomRoute(page: const Authenticate()));
              },
              icon: const Icon(Icons.exit_to_app)
            )
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            customButton("Add Service", addServiceNavigation, width(context)*0.5),
            FloatingActionButton(
              onPressed: () async{
                //Chat Rooms
                Navigator.of(context).push(CustomRoute(page: ChatRoom(primaryUserId: widget.user.userId)));
              },
              tooltip: 'Message',
              backgroundColor: Colors.white,
              child: Icon(Icons.message, color: AppColors.themeColor),
            ),
          ],
        ),
        body: StreamBuilder<List<Services>>(
          stream: DatabaseService(uid: widget.user.userId).getServicesList,
          builder: (context, snapshot){
            if(snapshot.hasData){
              if(snapshot.data?.length != 0){
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index){
                    Services services = snapshot.data![index];
                    return customTile(widget.user, services, context, editService, false);
                  },
                );
              }else if (snapshot.data?.length == 0){
                return SizedBox(
                  height: height(context)*0.8,
                  child: Center(
                    child: Text(
                      "No Services",
                      style: textStyleForQuestionAndAnswer.apply(
                          fontSizeFactor: 1.5,
                          color: Colors.grey[400]
                      ),
                    ),
                  ),
                );
              }else{
                return Container();
              }
            }else{
              return const Center(child: CircularProgressIndicator());
            }
          },
        )
      ),
    );
  }

  void addServiceNavigation() async{
    Navigator.of(context).push(CustomRoute(page: AddService(userId: widget.user.userId)));
  }

  void editService(User user, Services services) async{

  }

}
