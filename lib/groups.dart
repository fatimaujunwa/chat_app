import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ichat/text_dimensions.dart';

import 'app_colors.dart';
import 'custom_textfield.dart';
import 'database_services.dart';

class GroupListPage extends StatefulWidget {
   GroupListPage({Key? key,required this.uid,required this.username}) : super(key: key);
var uid;
final String username;
  @override
  State<GroupListPage> createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  Widget LatestChats(){
    return  StreamBuilder(
      stream: DatabaseServices(uid: widget.uid).getGroups(),
      builder: (context,AsyncSnapshot snapshot ){

        return snapshot.hasData ?
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
                          backgroundColor: AppColors.middleShadeNavyBlue,
                          child: Text('',style: TextDimensions.style17RajdhaniW600White,),
                          // backgroundImage: AssetImage('images/${images[index]}'),
                        ),
                        // SizedBox(width: 5.w,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(snapshot.data!.docs[index]["groupName"],style: TextDimensions.style17RajdhaniW600White,),
                            SizedBox(height: 10.h,),
                            Text(snapshot.data!.docs[index]["message"],style: TextDimensions.style12RajdhaniW600White,)
                          ],),
                        SizedBox(width: 10.w,),
                        Column(
                          children: [
                            Text('TUES 8:34',style: TextDimensions.style12RajdhaniW600White,),
                            SizedBox(height: 10.h,),

                            Row(
                              children: [
                                Text('members:  ',style: TextDimensions.style12RajdhaniW600White,),
                                CircleAvatar(radius: 10,backgroundColor: AppColors.darkBlue,child: Text('5'),),
                              ],
                            ),
                          ],
                        ),
                        // Divider(height: 10,color: AppColors.whiteColor,thickness: 2,)


                      ],),
                  ),
                  Divider(height: 10,color: AppColors.lightNavyBlue,thickness: 1,)
                ],
              );



            }):Center(
          child: Container(
            height: 100,
            width: 100,
            color: Colors.red,

          ),
        );
      },


    );
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController search=TextEditingController();
    List <String> letters=["H","C","A","S","SM","G","F","K"];
    return
      Container(
        margin: EdgeInsets.only(top: 50.h,left: 20.w,right: 20.w),
        // color: AppColors.darkNavyBlue,
        child: SingleChildScrollView(
          child: Column(children: [
            Text('Support Groups',style: TextDimensions.style36RajdhaniW700White,),
            SizedBox(height: 20.h,),
            CustomTextField(
              icon:Icon( Icons.search),
              hintText: 'Search...',
              prefixIcon: true,
              obsText: false,
              suffixIcon: false,
              height: 80.h,
              width: 350.w,
              color: AppColors.middleShadeNavyBlue,
              controller:  search,
            ),
LatestChats()
          ],),
        ),

      );
  }
}
