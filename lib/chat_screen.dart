
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ichat/app_colors.dart';
import 'package:ichat/custom_textfield.dart';
import 'package:ichat/text_dimensions.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List <String> images=['image1.jpg','image2.jpg','image3.jpg',
      'image5.jpg','image6.jpg','image7.jpg','image8.jpg','image9.jpg'

    ];
    TextEditingController search =TextEditingController();
    return Scaffold(
      backgroundColor: AppColors.darkNavyBlue,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.darkBlue,
        onPressed: () {},
        child: Icon(Icons.add),
      ),
        bottomNavigationBar: FloatingNavbar(
          selectedItemColor: AppColors.darkBlue,
          unselectedItemColor: AppColors.darkNavyBlue,
          backgroundColor: AppColors.whiteColor,
          onTap: (int val) {
            //returns tab id which is user tapped
          },
          currentIndex: 0,
          items: [
            FloatingNavbarItem(icon: Icons.home, title: 'Home'),
            FloatingNavbarItem(icon: Icons.explore, title: 'Explore'),
            FloatingNavbarItem(icon: Icons.chat_bubble_outline, title: 'Chats'),
            FloatingNavbarItem(icon: Icons.settings, title: 'Settings'),
          ],
        ),


      body: SingleChildScrollView(
        child: Container(
margin: EdgeInsets.only(top: 50.h,left: 20.w,right: 20.w),
          color: AppColors.darkNavyBlue,
child:
Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    Text('Chats',style: TextDimensions.style36RajdhaniW700White,),
    SizedBox(height: 20.h,),
    CustomTextField(
      icon: Icons.search,
        hintText: 'Search..',
        prefixIcon: true,
        obsText: false,
        suffixIcon: false,
        height: 80.h,
        width: 350.w,
        color: AppColors.middleShadeNavyBlue,
        controller:  search,
    ),
    SizedBox(height: 8.h,),
    ListView.builder(
        shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: images.length,
          itemBuilder: (_,index){
        return
          Column(

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
                    Text('Ujunwa Fatima',style: TextDimensions.style17RajdhaniW600White,),
                      SizedBox(height: 10.h,),
                    Text('hey, can you help me get that..',style: TextDimensions.style12RajdhaniW600White,)
                  ],),
                  SizedBox(width: 10.w,),
                  Column(
                    children: [
                      Text('TUES 8:34',style: TextDimensions.style12RajdhaniW600White,),
                     SizedBox(height: 10.h,),
                     CircleAvatar(radius: 10,backgroundColor: AppColors.darkBlue,child: Text('5'),),
                    ],
                  ),
                  // Divider(height: 10,color: AppColors.whiteColor,thickness: 2,)


              ],),
            ),
            Divider(height: 10,color: AppColors.lightNavyBlue,thickness: 1,)
          ],
        );
    })
  ],
),

        ),
      ),
    );
  }
}
