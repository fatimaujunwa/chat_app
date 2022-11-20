import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ichat/members.dart';
import 'package:ichat/test.dart';
import 'package:ichat/text_dimensions.dart';

import 'app_colors.dart';
import 'chat_screen.dart';
import 'custom_textfield.dart';
import 'database_services.dart';
import 'group_chat.dart';
import 'groups.dart';
import 'my_groups.dart';
enum _SelectedTab { home, favorite, search, person }
class HomePage extends StatefulWidget {
   HomePage({Key? key,required this.uid,required this.username}) : super(key: key);
  var uid;
  var username;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var _selectedTab = _SelectedTab.home;
  bool haveUserSearched = false;
  bool tapped=false;

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
    });
  }

  createGroup(String userName,String id, String groupName )async{
    await DatabaseServices(uid: widget.uid).createGroup(userName, id, groupName);
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return GroupChatRoom(admin:userName,groupName:groupName,uid:widget.uid);
    }));
  }

  Future <void> create(TextEditingController controller) async {
    await showModalBottomSheet(
      isScrollControlled: true
      ,
      context: context, builder: (BuildContext context){
      return Padding(
        padding:  EdgeInsets.only(left: 20.0.w,right: 20.w,top: 20.h,bottom: MediaQuery.of(context).viewInsets.bottom+20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Create Group',style: TextDimensions.style36RajdhaniW700White,),
            SizedBox(height: 20.h,),
            CustomTextField(
              validator: (value ) {  },
              icon: InkWell(
                onTap: (){
                  setState(() {
                    tapped=false;
                  });

                },
                child: Icon(Icons.search),),
              hintText: 'Group Name',
              prefixIcon: true,
              obsText: false,
              suffixIcon: false,
              height: 80.h,
              width: 350.w,
              color: AppColors.middleShadeNavyBlue,
              controller: controller,
            ),
            SizedBox(height: 30.h,),
            BlueContainer(text: 'Create',onPressed: (){
              createGroup(widget.username,widget.uid, controller.text.trim());
            },),

          ],),
      )  ;
    },
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0.r),
          side: BorderSide(color: AppColors.lightNavyBlue)

      ),
      backgroundColor: AppColors.darkNavyBlue,


    );
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController groupName =TextEditingController();
    List pages=[ChatScreen(uid: widget.uid, username: widget.username),GroupListPage(uid: widget.uid, username: widget.username), MyGroups( username: widget.username, uid: widget.uid,),Test()];
    return Scaffold(
      backgroundColor: AppColors.darkNavyBlue,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.darkBlue,
        onPressed: () {
          create(groupName);

        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: DotNavigationBar(
          margin: EdgeInsets.only(left: 10, right: 10),
          currentIndex: _SelectedTab.values.indexOf(_selectedTab),
          dotIndicatorColor: Colors.white,
          unselectedItemColor: Colors.grey[300],
          // enableFloatingNavBar: false,
          onTap: _handleIndexChanged,
          items: [
            /// Home
            DotNavigationBarItem(
              icon: Icon(Icons.messenger_rounded),
              selectedColor: Color(0xff73544C),
            ),

            /// Likes
            DotNavigationBarItem(
              icon: Icon(Icons.group),
              selectedColor: Color(0xff73544C),
            ),

            /// Search
            DotNavigationBarItem(
              icon: Icon(Icons.group_remove_sharp),
              selectedColor: Color(0xff73544C),
            ),

      

          ],
        ),
        // FloatingNavbar(
        //   selectedItemColor: AppColors.darkBlue,
        //   unselectedItemColor: AppColors.darkNavyBlue,
        //   backgroundColor: AppColors.whiteColor,
        //   onTap: (int val) {
        //     //returns tab id which is user tapped
        //
        //     currIndex=val;
        //   },
        //   currentIndex: currIndex,
        //   items: [
        //     FloatingNavbarItem(icon: Icons.home, title: 'Home',
        //
        //
        //     ),
        //     FloatingNavbarItem(icon: Icons.explore, title: 'Explore',customWidget: Container()),
        //     FloatingNavbarItem(icon: Icons.chat_bubble_outline, title: 'Chats'),
        //     FloatingNavbarItem(icon: Icons.settings, title: 'Settings'),
        //   ],
        // ),


      ),
      body: pages[_SelectedTab.values.indexOf(_selectedTab)],
    );
  }
}
