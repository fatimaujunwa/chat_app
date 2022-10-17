
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ichat/app_colors.dart';
import 'package:ichat/chatroom.dart';
import 'package:ichat/custom_textfield.dart';
import 'package:ichat/group_chat.dart';
import 'package:ichat/groups.dart';
import 'package:ichat/text_dimensions.dart';

import 'chat.dart';
import 'database_services.dart';
import 'helper_functions.dart';
enum _SelectedTab { home, favorite, search, person }
class ChatScreen extends StatefulWidget {
   ChatScreen({Key? key,required this.uid,required this.username}) : super(key: key);
var uid;
var username;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool haveUserSearched = false;
  bool tapped=false;
  var sender='';
  QuerySnapshot? searchResultSnapshot;
  QuerySnapshot? searchLatestSnapshot;
  initiateSearch(TextEditingController searchEditingController) async {
    if(searchEditingController.text.isNotEmpty){
      await DatabaseServices(uid: widget.uid).searchUser(searchEditingController.text).then((value) {
        searchResultSnapshot = value;
        print("$searchResultSnapshot");
        setState(() {
          haveUserSearched=true;
        });
      });

    }
  }
  getUser() async {

    await HelperFunctions.getUserNameFromSF().then((value) {
      sender=value!;
    });

  }
  getChatRoomId(String? a, String b) {
    if (a!.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
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
  


  chatMessages()  {
    return StreamBuilder(
      stream:   DatabaseServices(uid: widget.uid).getLatestChats(),
      builder: (context, AsyncSnapshot snapshot){
        return snapshot.hasData ?
        ListView.builder(
          shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index){
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
                            backgroundImage: AssetImage('images/image1.jpg'),
                          ),
                          // SizedBox(width: 5.w,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text( '',style: TextDimensions.style17RajdhaniW600White,),
                              SizedBox(height: 10.h,),
                              Text(snapshot.data!.docs[index]["message"],style: TextDimensions.style12RajdhaniW600White,)
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
            }) : Container(height: 10,width: 10,color: Colors.red,);
      },
    );
  }
  Widget LatestChats(){
    return  StreamBuilder(
      stream: DatabaseServices(uid: widget.uid).searchLatestChats(widget.username
      ),
      builder: (context,AsyncSnapshot<QuerySnapshot> snapshot ){

        return snapshot.hasData ?
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index){
              return
                Column(

                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 5.h,bottom: 5.h),
                      height: 80.h ,
                      width: 350.w,

                      child: GestureDetector(
                        onTap: ()=> sendMessage(snapshot.data!.docs[index]["sendTo"]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            CircleAvatar(radius: 50.r,
                              backgroundColor: AppColors.darkNavyBlue,
                              backgroundImage: AssetImage('images/image1.jpg'),
                            ),
                            // SizedBox(width: 5.w,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(snapshot.data!.docs[index]["sendTo"]??'',style: TextDimensions.style17RajdhaniW600White,),
                                SizedBox(height: 10.h,),
                                Text(snapshot.data!.docs[index]["message"],style: TextDimensions.style12RajdhaniW600White,)
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
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    print('chats'+sender.toString());
// latestMessages();
    DatabaseServices(uid: widget.uid).searchLatestChats(sender
    );

  }
  var _selectedTab = _SelectedTab.home;

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
    });
  }

  @override
  Widget build(BuildContext context) {
    var pages=[GroupListPage(uid: widget.uid, username: widget.username)];
    List <String> images=['image1.jpg','image2.jpg','image3.jpg',
      'image5.jpg','image6.jpg','image7.jpg','image8.jpg','image9.jpg'

    ];

    int currIndex=0;
    TextEditingController search =TextEditingController();
    TextEditingController groupName =TextEditingController();
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
    icon: Icon(Icons.home),
    selectedColor: Color(0xff73544C),
    ),

    /// Likes
    DotNavigationBarItem(
    icon: Icon(Icons.favorite),
    selectedColor: Color(0xff73544C),
    ),

    /// Search
    DotNavigationBarItem(
    icon: Icon(Icons.search),
    selectedColor: Color(0xff73544C),
    ),

    /// Profile
    DotNavigationBarItem(
    icon: Icon(Icons.person),
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


         ),body:
      SingleChildScrollView(
        child:pages[_selectedTab]

//        Container(
// margin: EdgeInsets.only(top: 50.h,left: 20.w,right: 20.w),
//           color: AppColors.darkNavyBlue,
// child:
// Column(
//   crossAxisAlignment: CrossAxisAlignment.stretch,
//   children: [
//     Text('Chats',style: TextDimensions.style36RajdhaniW700White,),
//     SizedBox(height: 20.h,),
//     CustomTextField(
//       icon: InkWell(
//         onTap: (){
//           setState(() {
//             tapped=false;
//           });
//           initiateSearch(search);
//         },
//         child: Icon(Icons.search),),
//         hintText: 'Search..',
//         prefixIcon: true,
//         obsText: false,
//         suffixIcon: false,
//         height: 80.h,
//         width: 350.w,
//         color: AppColors.middleShadeNavyBlue,
//         controller:  search,
//     ),
//     SizedBox(height: 8.h,),
//
//     haveUserSearched?userList():
// // chatMessages()
// LatestChats()
//   ],
// ),
//
//         ),
      ),
    );
  }


  Widget userList(){
    return haveUserSearched ?


        ListView.builder(
        shrinkWrap: true,
        itemCount: searchResultSnapshot!.docs.length,
        itemBuilder: (context, index){
          return

            userTile(
            searchResultSnapshot!.docs[index]["firstname"],
            searchResultSnapshot!.docs[index]["email"],
          );
        }) :  Container(
      height: 100,
      width: 100,
      color: Colors.blue,

    );
  }
  Widget userTile(String userName,String userEmail){
    return
      GestureDetector(
        onTap: (){
          sendMessage(userName);
          setState(() {
            haveUserSearched=false;
          });
        },
        child: Container(
          padding: EdgeInsets.only(top: 5.h,bottom: 5.h),
          height: 80.h ,
          width: 350.w,

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              CircleAvatar(radius: 50.r,
                backgroundColor: AppColors.middleShadeNavyBlue,
                // backgroundImage: AssetImage('images/${images[index]}'),
              ),
              // SizedBox(width: 5.w,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userName,style: TextDimensions.style17RajdhaniW600White,),
                  SizedBox(height: 10.h,),
                  Text(userEmail,style: TextDimensions.style12RajdhaniW600White,)
                ],),
              SizedBox(width: 10.w,),
              Column(
                children: [
                  Text(''),
                  BlueContainer(onPressed: sendMessage(userName),),


                ],
              ),
              // Divider(height: 10,color: AppColors.whiteColor,thickness: 2,)


            ],),
        ),
      );
  }
  String sortChatId(String chatRoomId){
    List<String> sortedString = chatRoomId.split("");
    sortedString.sort();

    return sortedString.join();
  }
  sendMessage(String userName) async {
    List<String?> users = [ await HelperFunctions.getUserNameFromSF(),userName];

    String chatRoomId = sortChatId( getChatRoomId(await HelperFunctions.getUserNameFromSF(),userName));

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId" : chatRoomId,
    };
    DatabaseServices(uid: widget.uid).addChatRoom(chatRoom, chatRoomId);

    Navigator.push(context, MaterialPageRoute(
        builder: (context) => ChatRoomScreen(
          chatRoomId: chatRoomId,
          uid:widget.uid,
sendTo:userName,
          sentFrom:widget.username
        )
    ));

  }
}

class BlueContainer extends StatelessWidget {
  const BlueContainer({
    Key? key,this.text='Message',
   required this.onPressed
  }) : super(key: key);
final String text;
final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onPressed,

      child: Container(height: 35.h,width: 80.w,
        decoration: BoxDecoration(
            color: AppColors.darkBlue,
            borderRadius: BorderRadius.circular(6.r)
        ),
        alignment: Alignment.center,
        child: Text(text,style: TextDimensions.style15RajdhaniW400White,),
      ),
    );
  }
}
