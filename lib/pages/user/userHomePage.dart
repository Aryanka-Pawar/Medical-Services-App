import 'package:flutter/material.dart';
import 'package:health_app/pages/chat/chat_room.dart';
import 'package:health_app/pages/user/serviceHome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../authenticate/auth.dart';
import '../../models/service.dart';
import '../../models/user.dart';
import '../../service/firebaseDatabase.dart';
import '../../shared/constants.dart';
import '../../shared/customRoute.dart';
import '../../shared/helperFunctions.dart';
import 'addLocation.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {

  bool isLocation = false;

  String userLocation = "null";

  getUserLocation() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userLocation = prefs.getString(HelperFunctions.sharedPreferenceUserLocationKey) ?? "null";
    });
    print("\n\nUser Location: ${userLocation}\n\n");
  }

  @override
  void initState() {
    getUserLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // getUserLocation();

    return WillPopScope(
      onWillPop: () {
        return backPressed(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("User Panel"),
          backgroundColor: AppColors.themeColor,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(CustomRoute(page: const AddLocation()));
              },
              icon: const Icon(Icons.location_on)
            ),
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
            customButton(isLocation? "All Locations" : "Near My Location", setLocation, width(context)*0.5),
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
          stream: isLocation? DatabaseService(uid: userLocation).getLocationServicesList: DatabaseService(uid: widget.user.userId).getAllServicesList,
          builder: (context, snapshot){
            if(snapshot.hasData){

              if(snapshot.data?.length != 0){
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index){
                    Services services = snapshot.data![index];
                    return customTile(widget.user, services, context, serviceHomePage, true);
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

  void serviceHomePage(User user, Services services) {
    Navigator.of(context).push(CustomRoute(page: ServiceHome(user: user, services: services)));
  }

  void setLocation(){
    getUserLocation();
    setState(() {
      isLocation = !isLocation;
    });
  }

}
