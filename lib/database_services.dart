import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  final String? uid;
  DatabaseServices({this.uid});
  //gets the collection
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");
  final CollectionReference chatRoomCollection =
      FirebaseFirestore.instance.collection("chatroom");
  final CollectionReference addressCollection =
      FirebaseFirestore.instance.collection("address");
  //in each document add the user info
  Future updateUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  // getting user data
  Future<QuerySnapshot> gettingUserData(String email) async {
    QuerySnapshot snapshot =
    //checks each document field for the email
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  Future<QuerySnapshot> searchUser(String searchField) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: searchField).get();
    return snapshot;
  }

  //create chat room for two users
  Future addChatRoom(chatRoom, chatRoomId) async {
    return await chatRoomCollection.doc(chatRoomId).set(chatRoom);
  }

  //addMessage
  Future addMessage(String chatRoomId, chatMessageData) async {
    return await chatRoomCollection
        .doc(chatRoomId)
        .collection("chats").add(chatMessageData);

  }


 getUserChats(String itIsMyName)  {
    return  chatRoomCollection.doc(itIsMyName).collection('chats').orderBy('time').snapshots();

  }
}
