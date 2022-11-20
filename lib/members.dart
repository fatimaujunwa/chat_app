import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ichat/chat_screen.dart';
import 'package:ichat/text_dimensions.dart';

import 'app_colors.dart';
import 'custom_textfield.dart';
import 'database_services.dart';

class MembersList extends StatefulWidget {
   MembersList({Key? key, required this.uid, required this.groupName}) : super(key: key);
var uid;
final String groupName;
  @override
  State<MembersList> createState() => _MembersListState();
}

class _MembersListState extends State<MembersList> {
 members()  {
    return StreamBuilder(
      stream:   DatabaseServices(uid: widget.uid).getGroupMembers(widget.groupName),
      builder: (context, AsyncSnapshot snapshot){
        return snapshot.hasData ?
        Column(children: [
          Row(
            children: [
              Text(snapshot.data!.docs.length.toString(),style: TextDimensions.style36RajdhaniW700White,),
              Text(' Member(s)',style: TextDimensions.style36RajdhaniW700White,),
            ],
          ),

          ListView.builder(
              itemCount: snapshot.data!.docs.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (_,index){
                return  Column(

                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 5.h),
                      height: 60.h ,
                      width: 350.w,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          CircleAvatar(radius: 30.r,
                            backgroundColor: AppColors.middleShadeNavyBlue,
                            // backgroundImage: AssetImage('images/${images[index]}'),
                          ),
                          // SizedBox(width: 5.w,),
                          Text(snapshot.data!.docs[index]["members"],style: TextDimensions.style17RajdhaniW600White,),
                          SizedBox(width: 10.w,),
                          BlueContainer(

                              onPressed: (){

                          },
                          text: 'Message',
                          ),
                          // Divider(height: 10,color: AppColors.whiteColor,thickness: 2,)


                        ],),
                    ),
                    Divider(height: 10,color: AppColors.lightNavyBlue,thickness: 1,)
                  ],
                );



              })
        ],): Center(child: CircularProgressIndicator(color: AppColors.darkBlue,));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List <String> images=['image1.jpg','image2.jpg','image3.jpg',
      'image5.jpg','image6.jpg','image7.jpg','image8.jpg','image9.jpg'

    ];
    TextEditingController search =TextEditingController();
    return Scaffold(
      backgroundColor: AppColors.darkNavyBlue,
      body: Container(
        margin: EdgeInsets.only(top: 50.h,left: 20.w,right: 20.w),
        // color: AppColors.darkNavyBlue,
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(height: 20.h,),
            CustomTextField(
              validator: (value ) {  },
              icon: Icon(Icons.search,color: Colors.white,),
              hintText: 'Search...',
              prefixIcon: true,
              obsText: false,
              suffixIcon: false,
              height: 80.h,
              width: 350.w,
              color: AppColors.middleShadeNavyBlue,
              controller:  search,
            ),
            members()
          ],)

        ),

      ),
    );
  }
}
