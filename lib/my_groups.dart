import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ichat/group_chat.dart';
import 'package:ichat/text_dimensions.dart';
import 'package:intl/intl.dart';

import 'app_colors.dart';
import 'chat_screen.dart';
import 'custom_textfield.dart';
import 'database_services.dart';
class MyGroups extends StatefulWidget {
 MyGroups({Key? key,required this.uid,required this.username}) : super(key: key);
  var uid;
  final String username;
  @override
  State<MyGroups> createState() => _MyGroupsState();
}

class _MyGroupsState extends State<MyGroups> {
  bool haveUserSearched=false;
  bool tapped=false;
  bool joined=false;
  bool error=false;
  QuerySnapshot? searchResultSnapshot;
  QuerySnapshot? searchLatestSnapshot;
  initiateSearch(TextEditingController searchEditingController) async {
    if(searchEditingController.text.isNotEmpty){
      await DatabaseServices(uid: widget.uid).searchMyGroup(searchEditingController.text.toUpperCase()).then((value) {
        searchResultSnapshot = value;
        if(value.docs.isEmpty){
          print('group does not exist');
          setState(() {
            error=true;
          });
          setState(() {
            haveUserSearched=true;
          });
        }
        else{
          setState(() {
            haveUserSearched=true;
          });
          setState(() {
            error=false;
          });
        }
      });

    }
  }
  Widget dateTimeConversion(DateTime time){
    final DateTime now = time;
    // DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss")
    //     .parse(now);
    // var inputData = DateTime.parse(parseDate.toString());
    final DateFormat formatter =  DateFormat.yMd('en_US');
    final String formatted = formatter.format(now);
    print(formatted);
    return  Text(formatted,style: TextDimensions.style12RajdhaniW600White,);

  }
  Widget LatestChats(){
    return  StreamBuilder(
      stream: DatabaseServices(uid: widget.uid).getUserGroups(),
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
                      height: 70.h ,
                      width: 350.w,

                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          CircleAvatar(radius: 30.r,
                            backgroundColor: AppColors.middleShadeNavyBlue,
                            child: Text(snapshot.data!.docs[index]["groupIcon"],style: TextDimensions.style17RajdhaniW600White,),
                            // backgroundImage: AssetImage('images/${images[index]}'),
                          ),
                          SizedBox(width: 20.w,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(snapshot.data!.docs[index]["groupName"],style: TextDimensions.style17RajdhaniW600White,),
                              SizedBox(height: 10.h,),
                              Text(snapshot.data!.docs[index]["message"],style: TextDimensions.style12RajdhaniW600White,)
                            ],),
                          Expanded(child: Container()),
                          Column(
                            children: [
                              dateTimeConversion(
                                  (snapshot.data!.docs[index]['time'] as Timestamp).toDate()
                              ),
                              SizedBox(height: 10.h,),

                              BlueContainer(
                                text: 'Remove',
                                onPressed: (){
DatabaseServices(uid: widget.uid).toggle(snapshot.data!.docs[index]["groupName"]);
                                  setState(() {
                                    haveUserSearched=false;
                                  });
                                  // Navigator.push(context, MaterialPageRoute(builder: (context){
                                  //   return GroupChatRoom(admin:snapshot.data!.docs[index]["sendBy"], groupName: snapshot.data!.docs[index]["groupName"], uid: widget.uid);
                                  // }
                                  //
                                  //
                                  // )
                                  //
                                  // );


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
      Scaffold(
        backgroundColor: AppColors.darkNavyBlue,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

            Container(
              margin: EdgeInsets.only(top: 50.h,left: 20.w,right: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text('My Groups',style: TextDimensions.style36RajdhaniW700White,),
              SizedBox(height: 20.h,),
              CustomTextField(
                validator: (value ) {  },
                icon:InkWell(
                    onTap: (){
                      setState(() {
                        tapped=false;
                      });
                      initiateSearch(search);
                    },
                    child: Icon(Icons.search,color: Colors.white,)),
                hintText: 'Search...',
                prefixIcon: true,
                obsText: false,
                suffixIcon: false,
                height: 80.h,
                width: 350.w,
                color: AppColors.middleShadeNavyBlue,
                controller:  search,
              ),
                haveUserSearched&& error? Text(''):
                haveUserSearched==true && error==false?

                GestureDetector(
                    onTap: (){
                      setState(() {
                        haveUserSearched=true;
                        error=true;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Icon(Icons.cancel,color: Colors.white,),
                    )): Text('')

                ,



                haveUserSearched&& error? LatestChats():
                haveUserSearched==true && error==false? userList():LatestChats()
            ],),)

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
              searchResultSnapshot!.docs[index]["groupIcon"],
            );
        }) :  Container(
      height: 100,
      width: 100,
      color: Colors.blue,

    );
  }
  Widget userTile(String groupName,String admin, String groupIcon)     {
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

            CircleAvatar(radius: 30.r,
            backgroundColor: AppColors.middleShadeNavyBlue,
            child: Text(groupIcon,style: TextDimensions.style17RajdhaniW600White,),
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



