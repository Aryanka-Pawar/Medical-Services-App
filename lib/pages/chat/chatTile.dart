import 'package:flutter/material.dart';
import 'package:health_app/shared/constants.dart';
import '../../models/chat.dart';
import '../../models/user.dart';
import '../../service/firebaseDatabase.dart';
import '../../shared/customRoute.dart';
import 'chat.dart';

class ChatTile extends StatefulWidget {

  final Chats chat;
  final String primaryUserId;
  const ChatTile({required this.chat, required this.primaryUserId});

  @override
  _ChatTileState createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<User>(
      stream: DatabaseService(uid: widget.primaryUserId == widget.chat.primaryUserId ? widget.chat.secondaryUserId: widget.chat.primaryUserId).getUser,
      builder: (context, snapshot) {

        User? userData = snapshot.data;

        if(snapshot.hasData) {
          return ListTile(
            onTap: () {
              Navigator.of(context).push(CustomRoute(page: Chat(chats: widget.chat, primaryUserId: widget.primaryUserId)));
            },
            leading: Icon(Icons.person, size: 40, color: AppColors.themeColor),
            title: Hero(
              tag: widget.chat.chatId,
              child: Text(
                userData!.userName,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'Public Sans',
                  color: Colors.black
                )
              ),
            ),
            subtitle: Text(
              userData.userEmail,
              style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'Public Sans',
                  color: Colors.black
              )
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 15,
              color: AppColors.themeColor,
            )
          );
        }else{
          return Container();
        }
      }
    );
  }
}
