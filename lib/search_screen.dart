import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ichat/database_services.dart';
import 'package:ichat/helper_functions.dart';

import 'chat.dart';

class SearchScreen extends StatefulWidget {
 SearchScreen({Key? key,required this.uid}) : super(key: key);
var uid;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool haveUserSearched = false;
 QuerySnapshot? searchResultSnapshot;
  initiateSearch(TextEditingController searchEditingController) async {
    if(searchEditingController.text.isNotEmpty){
     await DatabaseServices(uid: widget.uid).searchUser(searchEditingController.text).then((value) {
       searchResultSnapshot = value;
       print("$searchResultSnapshot");
       setState(() {
         haveUserSearched=true;
       });
     });

    }
  }

  getChatRoomId(String? a, String b) {
    if (a!.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {

    TextEditingController search=TextEditingController();
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 60),
        child: Column(

children: [

  TextField(
    controller: search,
    decoration: InputDecoration(
      suffixIcon: GestureDetector(
        onTap: () async {
 initiateSearch(search);
        },
          child: Icon(Icons.search,size: 20,)),
        hintText: 'search',
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red))),
  ),
  SizedBox(height: 16,),
  haveUserSearched?
  userList():Container(),
  SizedBox(height: 10,),

],
        ),
      ),
    );
  }
  Widget userList(){
    return haveUserSearched ? ListView.builder(
        shrinkWrap: true,
        itemCount: searchResultSnapshot!.docs.length,
        itemBuilder: (context, index){
          return userTile(
            searchResultSnapshot!.docs[index]["fullName"],
            searchResultSnapshot!.docs[index]["email"],
          );
        }) : Container();
  }
  Widget userTile(String userName,String userEmail){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16
                ),
              ),
              Text(
                userEmail,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16
                ),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              sendMessage(userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(24)
              ),
              child: Text("Message",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),),
            ),
          )
        ],
      ),
    );
  }
  String sortChatId(String chatRoomId){
    List<String> sortedString = chatRoomId.split("");
    sortedString.sort();

    return sortedString.join();
  }
  sendMessage(String userName) async {
    List<String?> users = [ await HelperFunctions.getUserNameFromSF(),userName];

    String chatRoomId = sortChatId( getChatRoomId(await HelperFunctions.getUserNameFromSF(),userName));

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId" : chatRoomId,
    };
DatabaseServices(uid: widget.uid).addChatRoom(chatRoom, chatRoomId);

    Navigator.push(context, MaterialPageRoute(
        builder: (context) => Chat(
          chatRoomId: chatRoomId,
          uid:widget.uid,

        )
    ));

  }
}
