import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                              Text(snapshot.data!.docs[index]["members"],style: TextDimensions.style17RajdhaniW600White,),

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
              icon: Icon(Icons.search),
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
