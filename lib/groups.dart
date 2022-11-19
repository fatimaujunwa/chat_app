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
  bool joined=false;
  bool error=false;
  QuerySnapshot? searchResultSnapshot;
  QuerySnapshot? searchLatestSnapshot;

  // addToUserGroupList(searchField) async {
  //
  // }

  initiateSearch(TextEditingController searchEditingController) async {
    if(searchEditingController.text.isNotEmpty){
      await DatabaseServices(uid: widget.uid).searchGroup(searchEditingController.text.toUpperCase()).then((value) {
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
addToList(String groupName ) async {

}

  Widget UserChats(){
    return  StreamBuilder(
      stream: DatabaseServices(uid: widget.uid).getUserGroups(),
      builder: (context,AsyncSnapshot snapshot ){

        return snapshot.hasData ?
        ListView.builder(
            itemCount: snapshot.data!.docs.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (_,index){
              return snapshot.data!.docs[index]["joined"]?  WhiteContainer(onPressed: (){

              }):BlueContainer(onPressed: () async {
                await DatabaseServices(uid: widget.uid).joinGroup(snapshot.data!.docs[index]["groupName"], snapshot.data!.docs[index]["message"],  snapshot.data!.docs[index]["sendBy"]);
                setState(() {
                  joined=true;
                  haveUserSearched=false;
                });
              });



            }):
        Center(
          child:
          CircularProgressIndicator(color: AppColors.darkBlue,),
        );
      },


    );
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
List group=["ALCOHOL", 'CANCER', 'DRUGS', 'PTSD'];

@override
  void initState() {
    // TODO: implement initState
    super.initState();

    }
   bool x=false;


  

  @override
  Widget build(BuildContext context) {
    Widget AddToList(String groupName,String group){
      return StreamBuilder(
          stream:DatabaseServices(uid: widget.uid).getData(groupName),
          builder: (context,AsyncSnapshot snapshot){
        return snapshot.hasData && snapshot.data!.docs.length>0 ?
            WhiteContainer(
                text: 'Joined',
                onPressed: (){
              
            }):BlueContainer(
            text: 'Join',
            onPressed: ()async{
              await DatabaseServices(uid: widget.uid).searchGroup(groupName).then((value){
                print(value.docs.length);
                DatabaseServices(uid: widget.uid).updateUserGroupMessages(groupName,

                    {
                      "sendBy":value.docs[0]['sendBy'],
                      "message":value.docs[0]['message'],
                      'time': value.docs[0]['time'],
                      "groupName":value.docs[0]['groupName'],
                      "groupIcon":value.docs[0]['groupIcon']
                    });

              });
        setState(() {
          haveUserSearched=false;
        });
              
        });
      });
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
                    (){
                      List groupList=[];
groupList.add( snapshot.data!.docs[index]["groupName"]);
print('groupList: $groupList');


                    }();
                return  Column(

                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return GroupChatRoom(admin: snapshot.data!.docs[index]["sendBy"], groupName:
                          snapshot.data!.docs[index]["groupName"], uid: widget.uid);
                        }));
                      },
                      child: Container(
                        padding: EdgeInsets.only(bottom: 5.h),
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
                                Container(
                                    margin: EdgeInsets.only(top: 13.h),
                                    child: Text(snapshot.data!.docs[index]["groupName"] ,style: TextDimensions.style17RajdhaniW600White,)),



                                SizedBox(height: 10.0.h,),
                                Text(snapshot.data!.docs[index]["message"],style: TextDimensions.style12RajdhaniW600White,)
                              ],),
                            Expanded(child: Container()),
                            Column(
                              children: [
                                dateTimeConversion(
                                    (snapshot.data!.docs[index]['time'] as Timestamp).toDate()
                                ),
                                SizedBox(height: 10.h,),
AddToList(snapshot.data!.docs[index]["groupName"],snapshot.data!.docs[index]['groupName'])



// Text(test(groupList[index]).toString())


                      // BlueContainer(
                      //             text: 'Add To List',
                      //             onPressed: ()async{
                      //
                      //
                      //
                      //
                      //
                      //
                      //               // await DatabaseServices(uid: widget.uid).joinGroup(snapshot.data!.docs[index]["groupName"], snapshot.data!.docs[index]["message"],  snapshot.data!.docs[index]["sendBy"]);
                      //
                      //               );
                      //
                      //               // Navigator.push(context, MaterialPageRoute(builder: (context){
                      //               //   return GroupChatRoom(admin:snapshot.data!.docs[index]["sendBy"], groupName: snapshot.data!.docs[index]["groupName"], uid: widget.uid);
                      //               // }));
                      //
                      //
                      //             },),
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
                Text('Support Groups',style: TextDimensions.style36RajdhaniW700White,),
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
                      child: Icon(Icons.search,color: AppColors.whiteColor,)),
                  hintText: 'Search...',
                  prefixIcon: true,
                  obsText: false,
                  suffixIcon: false,
                  height: 50.h,
                  width: 350.w,
                  color: AppColors.middleShadeNavyBlue,
                  controller:  search,
                ),
// SizedBox(height: 15.h,),
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
                      child: Container(
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.cancel,color: Colors.white,)),
                    )): Text('')
                
                ,
            
                
                
                haveUserSearched&& error? LatestChats():
                haveUserSearched==true && error==false? userList():LatestChats()
                // haveUserSearched?userList():
                // LatestChats()

              ],
            ),)


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
  Widget userTile(String groupName,String admin,String groupIcon)     {
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
        child:
        Container(
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

