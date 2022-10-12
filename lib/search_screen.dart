import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ichat/chat_screen.dart';
import 'package:ichat/chatroom.dart';
import 'package:ichat/database_services.dart';
import 'package:ichat/helper_functions.dart';
import 'package:ichat/text_dimensions.dart';

import 'app_colors.dart';
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
            searchResultSnapshot!.docs[index]["firstname"],
            searchResultSnapshot!.docs[index]["email"],
          );
        }) : Container();
  }
  Widget userTile(String userName,String userEmail){
    return
      Container(
        padding: EdgeInsets.only(top: 5.h,bottom: 5.h),
        height: 80.h ,
        width: 350.w,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            CircleAvatar(radius: 50.r,
              backgroundColor: AppColors.darkNavyBlue,
              // backgroundImage: AssetImage('images/${images[index]}'),
            ),
            // SizedBox(width: 5.w,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName,style: TextDimensions.style17RajdhaniW600White,),
                SizedBox(height: 10.h,),
                Text(userEmail,style: TextDimensions.style12RajdhaniW600White,)
              ],),
            SizedBox(width: 10.w,),
            Column(
              children: [
                Text(''),
                Container(height: 35.h,width: 80.w,
                  decoration: BoxDecoration(
                      color: AppColors.darkBlue,
                      borderRadius: BorderRadius.circular(6.r)
                  ),
                  alignment: Alignment.center,
                  child: Text('Message',style: TextDimensions.style15RajdhaniW400White,),
                ),


              ],
            ),
            // Divider(height: 10,color: AppColors.whiteColor,thickness: 2,)


          ],),
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
        builder: (context) => ChatRoomScreen(
          chatRoomId: chatRoomId,
          uid:widget.uid,

        )
    ));

  }
}
