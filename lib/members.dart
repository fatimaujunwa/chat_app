import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ichat/text_dimensions.dart';

import 'app_colors.dart';
import 'custom_textfield.dart';

class MembersList extends StatelessWidget {
  const MembersList({Key? key}) : super(key: key);

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
            Row(
              children: [
                Text('12 ',style: TextDimensions.style36RajdhaniW700White,),
                Text('Members',style: TextDimensions.style36RajdhaniW700White,),
              ],
            ),
            SizedBox(height: 20.h,),
            CustomTextField(
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
            ListView.builder(
                itemCount: images.length,
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
                              backgroundImage: AssetImage('images/${images[index]}'),
                            ),
                            // SizedBox(width: 5.w,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Maria Ujunwa',style: TextDimensions.style17RajdhaniW600White,),
                                SizedBox(height: 10.h,),
                                Text('hey, can you help me get that..',style: TextDimensions.style12RajdhaniW600White,)
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
          ],),
        ),

      ),
    );
  }
}
