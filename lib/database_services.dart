import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  final CollectionReference latestChatCollection =
      FirebaseFirestore.instance.collection("latestChats");
  final CollectionReference latestGroupChatCollection =
      FirebaseFirestore.instance.collection("latestGroupChats");
  //in each document add the user info
  Future updateUserData(
      String firstname, String email, String groupName, String lastname) async {
    userCollection.doc(uid).collection('groups').doc(groupName).set({
      "group": groupName,
      "sendBy":"",
      "message":"",
      'time': DateTime.now(),
      "groupName":groupName,
      "groupIcon":groupName.substring(0,2).toUpperCase(),
      "joined":true
    });

    await groupCollection.doc(groupName).collection("members").add({
      "members":firstname
    });
    await groupCollection.doc(groupName).set({
      "groupName": groupName,
      "groupId": "",
      "admin":firstname
    });

   await latestGroupChatCollection.doc(groupName).set({
     "groupName":groupName,
     "groupIcon":groupName.substring(0,2).toUpperCase(),
     "sendBy":"",
     "message": "",
     'time': DateTime
         .now()
   }) ;

    return await userCollection.doc(uid).
    set(
        {
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

  Future<QuerySnapshot> searchGroup(String searchField) async {
    QuerySnapshot snapshot =
    await latestGroupChatCollection.where("groupName", isEqualTo: searchField).get();

    return snapshot;
  }
  Future<QuerySnapshot> searchMyGroup(String searchField) async {
    QuerySnapshot snapshot =
    await userCollection.doc(uid).collection("groups").where("groupName", isEqualTo: searchField).get();

    return snapshot;
  }



  //search latest chat

  Stream<QuerySnapshot<Object?>> searchLatestChats(String searchField) {
    Stream<QuerySnapshot> snapshot = latestChatCollection
        .where("sendBy", isEqualTo: searchField)
        .snapshots();
    return snapshot;
  }

  Stream<QuerySnapshot<Object?>> searchLatestGroupChats(String searchField) {
    Stream<QuerySnapshot> snapshot = latestGroupChatCollection
        .where("groupName", isEqualTo: searchField)
        .snapshots();
    return snapshot;
  }



  getGroups() {
    return  latestGroupChatCollection
        .snapshots();
  }

getUserGroups(){
   return userCollection.doc(uid).collection("groups").snapshots();
}

  //latest chat
  Future latestChat(chatRoomId, chat) async {
    return await latestChatCollection.doc(chatRoomId).set(chat);
  }

  Future latestGroupChat(groupId, chat) async {
    return await latestGroupChatCollection.doc(groupId).set(chat);
  }

  //create chat room for two users
  Future addChatRoom(chatRoom, chatRoomId) async {
    return await chatRoomCollection.doc(chatRoomId).set(chatRoom);
  }

  //addMessage
  Future addMessage(String chatRoomId, chatMessageData) async {
    return await chatRoomCollection
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData);
  }

  Future addGroupMessage(String groupId, chatMessageData) async {
    return await groupCollection
        .doc(groupId)
        .collection("messages")
        .add(chatMessageData);
  }

  getUserChats(String itIsMyName) {
    return chatRoomCollection
        .doc(itIsMyName)
        .collection('chats')
        .orderBy('time')
        .snapshots();
  }
  getGroupChats(String itIsMyName) {
    return groupCollection
        .doc(itIsMyName)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }

  getLatestChats() {
    return latestChatCollection.snapshots();
  }
  addGroupToUser(searchField){
    searchLatestChats(searchField);
  }
//change
updateUserGroupMessages(groupName, chatMessageData,) async {
  DocumentReference userDocumentReference = userCollection.doc(uid);
  await userDocumentReference.collection("groups").doc(groupName).set(
      chatMessageData);
}
  Future createGroup(String userName, String id, String groupName) async {
    await groupCollection.doc(groupName).collection("members").add({
      "members":userName
    });
    await groupCollection.doc(groupName).set({
      "groupName": groupName,
      "groupId": "",
      "admin":userName
    });



    DocumentReference userDocumentReference = userCollection.doc(uid);
    await userDocumentReference.collection("groups").doc(groupName).set({
      "sendBy":"",
      "message": "",
      'time': DateTime
          .now(),
      "groupName":groupName,
      "groupIcon":groupName.substring(0,2).toUpperCase(),
      "joined":true
    });

  }
joinGroup(String groupName,String message, String sendBy)async{
  DocumentReference userDocumentReference = userCollection.doc(uid);
  await userDocumentReference.collection("groups").doc(groupName).set({
    "sendBy":sendBy,
    "message": message,
    'time': DateTime
        .now(),
    "groupName":groupName,
    "groupIcon":groupName.substring(0,2).toUpperCase(),
    "joined":true
  });
}

  //creating group
Future test(String groupName) async {
  DocumentReference d = userCollection.doc(uid).collection("groups").doc(groupName);
  DocumentSnapshot documentSnapshot = await d.get();
  print(documentSnapshot['joined']);
  return documentSnapshot['joined'];
}

  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  // get group members
  Stream getGroupMembers(String groupId)  {
    return groupCollection.doc(groupId).collection("members").snapshots();
  }

  // search
  searchByName(String groupName) {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  // function -> bool
  Future<bool> isUserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }
Future toggle(String groupName)async{
userCollection.doc(uid).collection("groups").doc(groupName).delete()..then((value) {
  print('deleted');
});

  // DocumentReference userDocumentReference = userCollection.doc(uid).collection("groups").doc(groupName);
  // DocumentSnapshot documentSnapshot = await userDocumentReference.get();
  // List<dynamic> groups = await documentSnapshot['groupName'];
  // if(groups.contains(groupName)){
  //   userDocumentReference.delete()..then((value) => print('deleted'));
  // }
  // userDocumentReference.update({
  //   "joined":false
  // });

}
  // toggling the group join/exit
  Future toggleGroupJoin(
      String groupId, String userName, String groupName) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    // if user has our groups -> then remove then or also in other part re join
    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }

Stream<QuerySnapshot<Object?>> getData(String groupName){

    Stream<QuerySnapshot> snapshot= userCollection.doc('2sCfGjM6WnNonRH5OK1hqUmZUuo1').
    collection('groups').where("groupName", isEqualTo: groupName).snapshots();
  return snapshot;
}
  // Stream<QuerySnapshot<Object?>> searchLatestGroupChats(String searchField) {
  //   Stream<QuerySnapshot> snapshot = latestGroupChatCollection
  //       .where("groupName", isEqualTo: searchField)
  //       .snapshots();
  //   return snapshot;
  // }

//  Future<bool> getData(List groupName) async {
//
//     Color b=Colors.black;
//     for(int i=0;i<groupName.length;i++) {
//     final snapshot= await
//     userCollection.doc('2sCfGjM6WnNonRH5OK1hqUmZUuo1').
//     collection('groups').where("groupName", isEqualTo: groupName[i]).get().then((value) {
//       if(value.docs.length==0){
//         x=false;
//       }
//       else{
//         x=true;
//         print(value.docs.length);
//         print(groupName[i]);
//       }
//     });
//
// return x ;
//     //     .
//     // then((value) {
//     //   if(value==null){
//     //     print('it does not exist');
//     //
//     //   }
//     //   else{
//     //
//     //     print(value.docs.length);
//     //     print('it exist');
//     //   }
//     // });
//     //  CollectionReference userDocumentReference = userCollection.doc(uid).collection('groups');
//     //  QuerySnapshot<Object?> documentSnapshot = await userDocumentReference.get();
//     //
//     //
//     //   if (documentSnapshot.contains(groupName[i])) {
//     //     return true;
//     //   } else {
//     //     return false;
//     //   }
// //     if(snapshot==null){
// //       print('false');
// //
// //
// //     }
// //     else{
// // print('it is true');
// //     }
//     }
//
//   }

  // send message
  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }
}
