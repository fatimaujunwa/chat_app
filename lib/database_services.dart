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
  final CollectionReference latestChatCollection =
      FirebaseFirestore.instance.collection("latestChats");
  final CollectionReference latestGroupChatCollection =
      FirebaseFirestore.instance.collection("latestGroupChats");
  //in each document add the user info
  Future updateUserData(
      String firstname, String email, String groupName, String lastname) async {
    userCollection.doc(uid).collection('groups').add({
      "group": groupName,
    });
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


  Future createGroup(String userName, String id, String groupName) async {
    await groupCollection.doc(groupName).collection("members").add({
      "members":userName
    });
    await groupCollection.doc(groupName).set({
      "groupName": groupName,
      "groupId": "",
      "admin":userName
    });

    // DocumentReference groupDocumentReference = await groupCollection.add({
    //   "groupName": groupName,
    //   "groupIcon": "",
    //   "admin": "${id}_$userName",
    //   "members": [],
    //   "groupId": "",
    //   "recentMessage": "",
    //   "recentMessageSender": "",
    // });
    // update the members
    // await groupDocumentReference.update({
    //   "members": FieldValue.arrayUnion(["${uid}_$userName"]),
    //   "groupId": groupDocumentReference.id,
    // });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":
      FieldValue.arrayUnion([groupName])
    });
  }
  //creating group


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
