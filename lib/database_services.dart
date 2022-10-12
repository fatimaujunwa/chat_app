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
  Future updateUserData(String firstname, String email, String groupName,String lastname) async {
    userCollection.doc(uid).collection('groups').add({
      "group":groupName,
    });
    return await userCollection.doc(uid).set({
      "firstname": firstname,
      "lastname": lastname,
      "email": email,
      // "groups": [],
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

  //creating group
  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });
//after creating group name and all set the person that created as a first member
    await groupDocumentReference.update({
    "members": FieldValue.arrayUnion(["${uid}_$userName"]),
    "groupId": groupDocumentReference.id,
    });
//update the groups in the user collection
    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":
      FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
}}
