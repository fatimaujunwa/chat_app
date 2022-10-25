import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ichat/app_colors.dart';
import 'package:ichat/chat.dart';
import 'package:ichat/custom_textfield.dart';
import 'package:ichat/database_services.dart';
import 'package:ichat/text_dimensions.dart';

import 'helper_functions.dart';

class ChatRoomScreen extends StatefulWidget {
   ChatRoomScreen({Key? key,required this.chatRoomId,required this.uid,required this.sendTo,required this.sentFrom}) : super(key: key);
  final String chatRoomId;
var sendTo;
  var uid;
  var sentFrom;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  var sender='';
  // String sortChatId(){
  //   List<String> sortedString = widget.chatRoomId.split("");
  //   sortedString.sort();
  //
  //    return sortedString.join();
  //  }
  chatMessages()  {
    return StreamBuilder(
      stream:   DatabaseServices(uid: widget.uid).getUserChats(widget.chatRoomId),
      builder: (context, AsyncSnapshot snapshot){
        return snapshot.hasData ?  Expanded(
          child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index){
                return MessageTile(
                  message: snapshot.data!.docs[index]["message"],
                  sendByMe: sender== snapshot.data!.docs[index]["sendBy"],
                );
              }),
        ) : Container();
      },
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  getUser() async {

    await HelperFunctions.getUserNameFromSF().then((value) {
      sender=value!;
    });
    print('chats'+sender.toString());
  }
  // QuerySnapshot? searchResultSnapshot;
  // latestChat(TextEditingController controller)async{
  //   if(controller.text.isNotEmpty){
  //     await DatabaseServices(uid:widget.uid).latestChat(widget.chatRoomId).then((value) {
  //       searchResultSnapshot = value;
  //       print('${searchResultSnapshot!.docs[0]["message"]}');
  //       print('${searchResultSnapshot!.docs.length}');
  //     } );
  //   }
  //
  // }

  @override
  Widget build(BuildContext context) {
    TextEditingController messageEditingController=TextEditingController();
    addMessage() async {
      if (messageEditingController.text.isNotEmpty) {
        Map<String, dynamic> chatMessageMap = {
          "sendBy":await HelperFunctions.getUserNameFromSF(),
          "message": messageEditingController.text,
          'time': DateTime
              .now()

        };
        Map<String,dynamic>chat={
          "sendTo":widget.sendTo,
          "sendBy":await HelperFunctions.getUserNameFromSF(),
          "message": messageEditingController.text,
          'time': DateTime
              .now()
        }
        ;
        DatabaseServices(uid:widget.uid).addMessage(widget.chatRoomId, chatMessageMap);
DatabaseServices(uid: widget.uid).latestChat(widget.chatRoomId, chat);

        messageEditingController.clear();
      }
    }




    return Scaffold(
      backgroundColor: AppColors.darkNavyBlue,
      body: Stack(
        children:[
          Column(children: [
          SizedBox(height: 50.h,),
          Container(
            margin: EdgeInsets.only(left: 20.w,right: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(child: Row(children: [
                  InkWell(
                    onTap: (){
                      // Map<String,dynamic>chat={
                      //   "sendBy":sender,
                      //
                      //   'time': DateTime
                      //       .now()
                      // };
                      // DatabaseServices(uid: widget.uid).latestChat(widget.chatRoomId, chat);
                      Navigator.pop(context);
                    },
                      child: Icon(Icons.arrow_back_ios,size: 20,color: AppColors.whiteColor,)),
                  SizedBox(width: 10.w,),
                  CircleAvatar(radius: 35.r,
                    backgroundColor: AppColors.darkNavyBlue,
                    backgroundImage: AssetImage('images/image1.jpg'),

                  ),
                  SizedBox(width: 70.w,),
                ],),),

                Column(children: [
                  Text(widget.sendTo,style: TextDimensions.style15RajdhaniW400White,),
                  SizedBox(height: 10.h,),
                  Text(widget.sentFrom,style: TextDimensions.style15RajdhaniW400White,),
                ],)
              ],
            ),

          ),
          Divider(color: AppColors.lightNavyBlue,),
chatMessages()
        ],


          ),
          Container(alignment: Alignment.bottomCenter,
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              // color: Color(0x54FFFFFF),
              child: Row(
                children: [
                  Expanded(
                      child:
                      CustomTextField(
                        validator: (value ) {  },
                        icon: Icon(Icons.email_outlined),
                        hintText: 'Type Something...',
                        // prefixIcon: false,
                        obsText: false,
                        suffixIcon: false,
                        height: 80.h,
                        width: 350.w,

                        color: AppColors.middleShadeNavyBlue,
                        controller:  messageEditingController,
                      ),


                  ),
                  SizedBox(width: 16,),
                  GestureDetector(
                    onTap: () {
                      addMessage();

                    },
                    child: Icon(Icons.send,color: AppColors.darkBlue,size: 20,),
                  ),
                ],
              ),
            ),
          ),

        ]
      ),

    );
  }

}
