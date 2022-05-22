import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/chat.dart';
import '../../service/firebaseDatabase.dart';
import '../../shared/constants.dart';
import '../../shared/helperFunctions.dart';
import 'chatTile.dart';

class ChatRoom extends StatefulWidget {

  final String primaryUserId;
  const ChatRoom({required this.primaryUserId});

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom>{

  bool isDoctor = false;

  void getProf() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDoctor = prefs.getBool(HelperFunctions.sharedPreferenceIsDoctorKey) ?? false;
    });
  }


  @override
  void initState() {
    super.initState();
    getProf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        backgroundColor: AppColors.themeColor,
      ),
      body: StreamBuilder<List<Chats>>(
        stream: isDoctor == true? DatabaseService(uid: widget.primaryUserId).myUserChats2 : DatabaseService(uid: widget.primaryUserId).myUserChats1,
        builder: (context, snapshot){
          if(snapshot.hasData){
            if(snapshot.data?.length != 0){
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index){
                  Chats chat = snapshot.data![index];
                  return ChatTile(primaryUserId: widget.primaryUserId, chat: chat);
                },
              );
            }else if (snapshot.data?.length == 0){
              return SizedBox(
                height: height(context)*0.8,
                child: Center(
                  child: Text(
                    "No Messages",
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
    );
  }
}
