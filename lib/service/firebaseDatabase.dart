import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat.dart';
import '../models/service.dart';
import '../models/user.dart';

class DatabaseService{

  final String uid;
  // final String userName;
  // final List<DocumentSnapshot> snap;

  DatabaseService({required this.uid});

  ///Users
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  // Add User
  Future updateUserData (User user) async{
    return await usersCollection.doc(uid).set({
      'userId':user.userId,
      'userEmail' : user.userEmail,
      'userName': user.userName,
      'userPassword': user.userPassword,
      "isDoctor" : user.isDoctor,
    }, SetOptions(merge: true));
  }

  //List of User

  List<User> usersList(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return User(
          doc.get("userId"),
          doc.get("userEmail"),
          doc.get("userName"),
          doc.get("userPassword"),
          doc.get("isDoctor"),
      );
    }).toList();
  }

  Stream<List<User>> get users {
    return usersCollection.snapshots().map(usersList);
  }

  //User

  User userDataFromSnapshot (DocumentSnapshot snapshot) {
    return User(
      snapshot.get('userId'),
      snapshot.get('userEmail'),
      snapshot.get('userName'),
      snapshot.get('userPassword'),
      snapshot.get('isDoctor'),
    );
  }

  Stream<User> get getUser {
    return usersCollection.doc(uid).snapshots().map(userDataFromSnapshot);
  }


  ///Services
  final CollectionReference servicesCollection = FirebaseFirestore.instance.collection("services");

  // Add Service
  addServices(serviceRoom) async{
    await servicesCollection.doc().set(serviceRoom).catchError((e) {
      print(e);
    });
  }

  // List of Service
  List<Services> servicesList(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Services(
        doc.get("serviceId"),
        doc.get("serviceName"),
        doc.get("serviceDescription"),
        doc.get("serviceLocation"),
      );
    }).toList();
  }

  Stream<List<Services>> get getServicesList {
    return servicesCollection.where("serviceId", isEqualTo: uid).snapshots().map(servicesList);
  }

  Stream<List<Services>> get getAllServicesList {
    return servicesCollection.snapshots().map(servicesList);
  }

  Stream<List<Services>> get getLocationServicesList {
    return servicesCollection.where("serviceLocation", isEqualTo: uid).snapshots().map(servicesList);
  }

  //Service
  Services userServicesFromSnapshot (DocumentSnapshot snapshot) {
    return Services(
      snapshot.get('serviceId'),
      snapshot.get('serviceName'),
      snapshot.get('serviceDescription'),
      snapshot.get('serviceLocation'),
    );
  }

  Stream<Services> get getService {
    return servicesCollection.doc(uid).snapshots().map(userServicesFromSnapshot);
  }


  ///Chats
  final CollectionReference chatCollection = FirebaseFirestore.instance.collection("chatRoom");

  //Add Chat Room
  addChatRoom(chatRoom) {
    chatCollection.doc(uid).set(chatRoom).catchError((e) {
      print(e);
    });
  }

  // Add Chat
  addMessage(chatMessageData){
    chatCollection.doc(uid).collection("chats").add(chatMessageData).catchError((e){
      print(e.toString());
    });
  }

  //List of Chats
  // getChats(String chatRoomId) async{
  //   return chatCollection.doc(chatRoomId).collection("chats").orderBy('time').snapshots();
  // }

  List<ChatMessage> messageList(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ChatMessage(
        doc.get("chatMessage"),
        doc.get("chatTime"),
        doc.get("sendBy"),
      );
    }).toList();
  }

  Stream<List<ChatMessage>> get myUserChatMessage {
    return chatCollection.doc(uid).collection("chats").orderBy('chatTime', descending: true).snapshots().map(messageList);
  }

  //List of User Chat Room
  List<Chats> chatsList(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Chats(
          doc.get("chatId"),
          doc.get("primaryUserId"),
          doc.get("secondaryUserId"),
      );
    }).toList();
  }

  Stream<List<Chats>> get myUserChats1 {
    return chatCollection.where("primaryUserId" , isEqualTo: uid).snapshots().map(chatsList);
  }

  Stream<List<Chats>> get myUserChats2 {
    return chatCollection.where("secondaryUserId" , isEqualTo: uid).snapshots().map(chatsList);
  }


  ///Updation

  Future updateUserEmail (String userEmail) async{
    return await usersCollection.doc(uid).update({
      'userEmail': userEmail,
    });
  }

}