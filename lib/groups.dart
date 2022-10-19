import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ichat/group_chat.dart';
import 'package:ichat/text_dimensions.dart';

import 'app_colors.dart';
import 'chat_screen.dart';
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
  bool haveUserSearched=false;
  bool tapped=false;
  QuerySnapshot? searchResultSnapshot;
  QuerySnapshot? searchLatestSnapshot;
  initiateSearch(TextEditingController searchEditingController) async {
    if(searchEditingController.text.isNotEmpty){
      await DatabaseServices(uid: widget.uid).searchGroup(searchEditingController.text).then((value) {
        searchResultSnapshot = value;
        print("$searchResultSnapshot");
        setState(() {
          haveUserSearched=true;
        });
      });

    }
  }
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
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return GroupChatRoom(admin: snapshot.data!.docs[index]["sendBy"], groupName: snapshot.data!.docs[index]["groupName"], uid: widget.uid);
                      }));
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
                            child: Text(snapshot.data!.docs[index]["groupIcon"],style: TextDimensions.style17RajdhaniW600White,),
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

                              BlueContainer(
                                text: 'Join',
                                onPressed: (){

                                setState(() {
                                  haveUserSearched=false;
                                });
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                  return GroupChatRoom(admin:snapshot.data!.docs[index]["sendBy"], groupName: snapshot.data!.docs[index]["groupName"], uid: widget.uid);
                                }));


                              },),
                            ],
                          ),
                          // Divider(height: 10,color: AppColors.whiteColor,thickness: 2,)


                        ],),
                    ),
                  ),
                  Divider(height: 10,color: AppColors.lightNavyBlue,thickness: 1,)
                ],
              );



            }):
        Center(
          child:
          CircularProgressIndicator(color: AppColors.darkBlue,),
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
              icon:InkWell(
                onTap: (){
                  setState(() {
                    tapped=false;
                  });
                  initiateSearch(search);
                },
                child: Icon(Icons.search)),
              hintText: 'Search...',
              prefixIcon: true,
              obsText: false,
              suffixIcon: false,
              height: 80.h,
              width: 350.w,
              color: AppColors.middleShadeNavyBlue,
              controller:  search,
            ),
            haveUserSearched?userList():
LatestChats()
          ],),
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
              searchResultSnapshot!.docs[index]["groupName"],
              searchResultSnapshot!.docs[index]["sendBy"],
            );
        }) :  Container(
      height: 100,
      width: 100,
      color: Colors.blue,

    );
  }
  Widget userTile(String groupName,String admin)     {
    return
      GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return GroupChatRoom(admin: admin, groupName: groupName, uid: widget.uid);
          }));
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
                  Text(groupName,style: TextDimensions.style17RajdhaniW600White,),
                  SizedBox(height: 10.h,),
                  Text(admin,style: TextDimensions.style12RajdhaniW600White,)
                ],),
              SizedBox(width: 10.w,),
              Column(
                children: [
                  Text(''),
                  BlueContainer(onPressed: (){

                    setState(() {
                      haveUserSearched=false;
                    });
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return GroupChatRoom(admin: admin, groupName: groupName, uid: widget.uid);
                    }));


                  },),


                ],
              ),
              // Divider(height: 10,color: AppColors.whiteColor,thickness: 2,)


            ],),
        ),
      );
  }
}

