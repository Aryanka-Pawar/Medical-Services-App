import 'dart:async';
import 'package:flutter/material.dart';
import 'package:health_app/shared/constants.dart';
import '../../models/chat.dart';
import '../../service/firebaseDatabase.dart';

class Chat extends StatefulWidget {

  final Chats chats;
  final String primaryUserId;
  const Chat({required this.chats, required this.primaryUserId});

  @override
  _ChatState createState() => _ChatState();
}


class _ChatState extends State<Chat>{

  TextEditingController messageEditingController = TextEditingController();
  final _controller = ScrollController();

  Widget chatMessages(){
    return StreamBuilder<List<ChatMessage>>(
      stream: DatabaseService(uid: widget.chats.chatId).myUserChatMessage,
      builder: (context, snapshot){

        if(snapshot.hasData){

          if(snapshot.data?.length != 0){
            return ListView.builder(
              itemCount: snapshot.data?.length,
              controller: _controller,
              reverse: true,
              itemBuilder: (context, index){
                ChatMessage chatMessage = snapshot.data![index];
                return MessageTile(
                  chatMessage: chatMessage,
                  sendByMe: widget.primaryUserId == chatMessage.sendBy,
                );
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
    );
  }



  addMessage() async{
    // print(widget.primaryUserId);
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": widget.primaryUserId,
        "chatMessage": messageEditingController.text,
        'chatTime': DateTime.now().millisecondsSinceEpoch,
      };
      DatabaseService(uid: widget.chats.chatId).addMessage(chatMessageMap);
      setState(() {
        messageEditingController.text = "";
      });
      Timer(const Duration(milliseconds: 500), () => _controller.jumpTo(_controller.position.minScrollExtent));
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Message"),
        backgroundColor: AppColors.themeColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: chatMessages(),
              )
            ),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                height: MediaQuery.of(context).size.height*0.10,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Row(
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height*0.05,
                        width: MediaQuery.of(context).size.width*0.8,
                        child: TextField(
                          textInputAction: TextInputAction.send,
                          controller: messageEditingController,
                          cursorColor: AppColors.themeColor,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 13
                          ),
                          onTap: () {
                            // Timer(Duration(milliseconds: 300), () => _controller.jumpTo(_controller.position.minScrollExtent));
                          },
                          onEditingComplete: () {
                            addMessage();
                          },
                          decoration: InputDecoration(
                            hintText: "Message ...",
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                            filled: true,
                            fillColor:  Colors.grey.shade200,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.grey.shade200),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color:  Colors.grey.shade200),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color:  Colors.grey.shade200),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color:  Colors.grey.shade200),
                            ),
                            contentPadding: EdgeInsets.all(12.5)
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15,),
                    IconButton(
                      onPressed: () {
                        addMessage();
                      },
                      splashRadius: 1.0,
                      icon: Icon(
                        Icons.send,
                        color: AppColors.themeColor,
                        size: 23,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MessageTile extends StatelessWidget {

  final ChatMessage chatMessage;
  final bool sendByMe;
  MessageTile({required this.chatMessage, required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Color(0xffe7eefc),
      padding: EdgeInsets.only(top: 8,bottom: 8,left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe ? const EdgeInsets.only(left: 30) : const EdgeInsets.only(right: 30),
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
        decoration: BoxDecoration(
          borderRadius: sendByMe ? const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15)
          ) : const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15)
          ),
          gradient: LinearGradient(
            colors: sendByMe ? [
              Colors.white70,
              Colors.white,
            ]: [
              AppColors.themeColor,
              AppColors.themeColor.withOpacity(0.8),
              // AppColors.themeColor
            ],
          )
        ),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text : chatMessage.chatMessage,
                style: TextStyle(
                  color: sendByMe ? Colors.black : Colors.white,
                  fontSize: 13,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.normal
                ),
              ),
              TextSpan(
                text: "   ${getTimeDiff(DateTime.fromMillisecondsSinceEpoch(chatMessage.chatTime))}",
                style: TextStyle(
                  color: sendByMe ? Colors.grey[600] : Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w300,
                )
              ),
            ]
          )
        ),
      ),
    );
  }
}
