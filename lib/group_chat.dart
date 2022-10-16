import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ichat/text_dimensions.dart';

import 'app_colors.dart';
import 'chat.dart';
import 'custom_textfield.dart';

class GroupChatRoom extends StatelessWidget {
  const GroupChatRoom({Key? key,required this.admin, required this.groupName }) : super(key: key);
final String admin;
final String groupName;
  @override
  Widget build(BuildContext context) {
    TextEditingController messageEditingController= TextEditingController();
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
                      Icon(Icons.arrow_back_ios,size: 20,color: AppColors.whiteColor,),
                      SizedBox(width: 10.w,),
                      CircleAvatar(radius: 40.r,
                        backgroundColor: AppColors.middleShadeNavyBlue,
                        child: Text(groupName.substring(0, 2)
                            .toUpperCase(),style: TextDimensions.style36RajdhaniW700White,),
                        // backgroundImage: AssetImage('images/${images[index]}'),
                      ),
                      SizedBox(width: 70.w,),
                    ],),),

                    Column(children: [
                      Row(
                        children: [

                          SizedBox(width: 5.w,),
                          Text('View members',style: TextDimensions.style15RajdhaniW400White,),
                          Icon(Icons.arrow_right_alt_outlined,size: 20,color: AppColors.whiteColor,)
                        ],
                      ),
                      SizedBox(height: 10.h,),
                      Row(
                        children: [

                          Text('Group Admin: ',style: TextDimensions.style15RajdhaniW400White,),
                          Text(admin,style: TextDimensions.style15RajdhaniW400White,),
                        ],
                      ),
                      SizedBox(height: 10.h,),
                      Text(groupName,style: TextDimensions.style17RajdhaniW600White,),
                    ],)
                  ],
                ),

              ),
              Divider(color: AppColors.lightNavyBlue,),
              MessageTile(message: 'hi', sendByMe:false),
              MessageTile(message: 'hello', sendByMe:true),
              MessageTile(message: 'hi my name is ', sendByMe:false),
              MessageTile(message: 'hell i know', sendByMe:true)
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
                        // addMessage();
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
