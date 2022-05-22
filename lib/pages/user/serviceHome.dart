import 'package:flutter/material.dart';
import 'package:health_app/models/service.dart';
import '../../models/chat.dart';
import '../../models/user.dart';
import '../../service/firebaseDatabase.dart';
import '../../shared/constants.dart';
import '../../shared/customRoute.dart';
import '../chat/chat.dart';

class ServiceHome extends StatefulWidget {
  const ServiceHome({Key? key, required this.user, required this.services}) : super(key: key);
  final Services services;
  final User user;

  @override
  State<ServiceHome> createState() => _ServiceHomeState();
}

class _ServiceHomeState extends State<ServiceHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Service"),
        backgroundColor: AppColors.themeColor,
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          customButton("Book Service", bookService, width(context)*0.5),
          FloatingActionButton(
            onPressed: () async{
              //Start Chatting

              String chatId = getChatRoomId(widget.user.userId, widget.services.serviceId);
              Map<String, dynamic> chatRoom = {
                "chatId" : chatId,
                "primaryUserId" : widget.user.userId,
                "secondaryUserId" : widget.services.serviceId,
              };

              // print(chatId);
              // print(widget.user.userId);
              // print(widget.services.serviceId);

              DatabaseService(uid: chatId).addChatRoom(chatRoom);

              Chats chat = Chats(chatId, widget.user.userId, widget.services.serviceId);

              Navigator.of(context).push(CustomRoute(page: Chat(chats: chat, primaryUserId: widget.user.userId)));
            },
            tooltip: 'Message',
            backgroundColor: Colors.white,
            child: Icon(Icons.message, color: AppColors.themeColor),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20.0,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Align(
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              widget.services.serviceName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                              ),
                            )
                          ),
                          alignment: Alignment.topLeft,
                        ),
                        Align(
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                                widget.services.serviceDescription,
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            )
                          ),
                          alignment: Alignment.topLeft,
                        ),
                        Align(
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              widget.services.serviceLocation,
                              style: const TextStyle(
                                fontSize: 17,
                              ),
                            )
                          ),
                          alignment: Alignment.bottomRight,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0,),
            ],
          ),
        ),
      ),
    );
  }

  void bookService() async{
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${widget.services.serviceName} is Booked")));
  }

  getChatRoomId(String a, String b) {
    for (int i = 0; (i < a.length && i < b.length); i++) {
      if (a.codeUnitAt(i) == b.codeUnitAt(i))
        continue;
      if (a.codeUnitAt(i) < b.codeUnitAt(i)) {
        print("$a is smaller");
        return "$a\_$b";
      } else {
        print("$b is smaller");
        return "$b\_$a";
      }
    }
  }

}
