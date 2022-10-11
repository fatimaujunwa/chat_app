import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ichat/app_colors.dart';
import 'package:ichat/chat.dart';
import 'package:ichat/custom_textfield.dart';
import 'package:ichat/text_dimensions.dart';

class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController messageEditingController=TextEditingController();
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
                  Icon(Icons.arrow_back_ios,size: 20,color: AppColors.whiteColor,),
                  SizedBox(width: 10.w,),
                  CircleAvatar(radius: 35.r,
                    backgroundColor: AppColors.darkNavyBlue,
                    backgroundImage: AssetImage('images/image1.jpg'),

                  ),
                  SizedBox(width: 70.w,),
                ],),),

                Column(children: [
                  Text('Ujunwa Peter',style: TextDimensions.style15RajdhaniW400White,),
                  SizedBox(height: 10.h,),
                  Text('Ujunwa Fatima',style: TextDimensions.style15RajdhaniW400White,),
                ],)
              ],
            ),

          ),
          Divider(color: AppColors.lightNavyBlue,),
     MessageTile(message: 'hi', sendByMe:false),
          MessageTile(message: 'hello', sendByMe:true),
          MessageTile(message: 'hi my name is i ', sendByMe:false),
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
                        icon: Icons.email_outlined,
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
