import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ichat/members.dart';
import 'package:ichat/text_dimensions.dart';

import 'app_colors.dart';
import 'chat.dart';
import 'custom_textfield.dart';
import 'database_services.dart';
import 'helper_functions.dart';

class GroupChatRoom extends StatefulWidget {
  GroupChatRoom({Key? key,required this.admin, required this.groupName ,required this.uid}) : super(key: key);
final String admin;
final String groupName;
var uid;

  @override
  State<GroupChatRoom> createState() => _GroupChatRoomState();
}

class _GroupChatRoomState extends State<GroupChatRoom> {
  var sender='';

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

  }
  @override
  Widget build(BuildContext context) {
    TextEditingController messageEditingController= TextEditingController();
    chatMessages()  {
      return StreamBuilder(
        stream:   DatabaseServices(uid: widget.uid).getGroupChats(widget.groupName),
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
    addMessage() async {
      if (messageEditingController.text.isNotEmpty) {
        Map<String, dynamic> chatMessageMap = {
          "sendBy":await HelperFunctions.getUserNameFromSF(),
          "message": messageEditingController.text,
          'time': DateTime
              .now(),
          "groupName":widget.groupName,
          "groupIcon":widget.groupName.substring(0,2).toUpperCase(),

        };
        Map<String,dynamic>chat={
          "groupName":widget.groupName,
          "groupIcon":widget.groupName.substring(0,2).toUpperCase(),
          "sendBy":await HelperFunctions.getUserNameFromSF(),
          "message": messageEditingController.text,
          'time': DateTime
              .now()
        }
        ;
        DatabaseServices(uid:widget.uid).addGroupMessage(widget.groupName, chatMessageMap);
        DatabaseServices(uid: widget.uid).latestGroupChat(widget.groupName, chat);

        messageEditingController.clear();
      }
    }

    return Scaffold(
      backgroundColor: AppColors.darkNavyBlue,
      body: Stack(
          children:[
            Column(children: [
              SizedBox(height: 40.h,),
              Container(
                margin: EdgeInsets.only(left: 20.w,right: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(child: Row(children: [
                      InkWell(
                        onTap: ()=>Navigator.pop(context),
                        
                          child: Icon(Icons.arrow_back_ios,size: 20,color: AppColors.whiteColor,)),
                      SizedBox(width: 10.w,),
                      CircleAvatar(radius: 40.r,
                        backgroundColor: AppColors.middleShadeNavyBlue,
                        child: Text(widget.groupName.substring(0, 2)
                            .toUpperCase(),style: TextDimensions.style36RajdhaniW700White,),
                        // backgroundImage: AssetImage('images/${images[index]}'),
                      ),
                      SizedBox(width: 70.w,),
                    ],),),

                    Column(children: [
                      GestureDetector(
                        onTap:()=>Navigator.push(context, MaterialPageRoute(builder: (context){
                          return MembersList(uid:widget.uid,groupName:widget.groupName);
                        })),
                        child: Container(
                          child: Row(
                            children: [

                              SizedBox(width: 5.w,),
                              Text('View members',style: TextDimensions.style15RajdhaniW400White,),
                              Icon(Icons.arrow_right_alt_outlined,size: 20,color: AppColors.whiteColor,)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h,),
                      Row(
                        children: [

                          Text('Group Admin: ',style: TextDimensions.style15RajdhaniW400White,),
                          Text(widget.admin,style: TextDimensions.style15RajdhaniW400White,),
                        ],
                      ),
                      SizedBox(height: 10.h,),
                      Text(widget.groupName,style: TextDimensions.style17RajdhaniW600White,),
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
