import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ichat/app_colors.dart';
import 'package:ichat/database_services.dart';
import 'package:ichat/helper_functions.dart';
import 'package:ichat/text_dimensions.dart';

class Chat extends StatefulWidget {
 Chat({Key? key, required this.chatRoomId,required this.uid}) : super(key: key);
final String chatRoomId;

var uid;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  var sender='';
 // String sortChatId(){
 //   List<String> sortedString = widget.chatRoomId.split("");
 //   sortedString.sort();
 //
 //    return sortedString.join();
 //  }
  chatMessages()  {
    return StreamBuilder(
      stream:   DatabaseServices(uid: widget.uid).getUserChats(widget.chatRoomId),
      builder: (context, AsyncSnapshot snapshot){
        return snapshot.hasData ?  ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index){
              return MessageTile(
               message: snapshot.data!.docs[index]["message"],
                sendByMe: sender== snapshot.data!.docs[index]["sendBy"], sentFrom: '', sentTo: '',
              );
            }) : Container();
      },
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
getUser();
  }

  getUser() async {

    await HelperFunctions.getUserNameFromSF().then((value) {
     sender=value!;
    });
print('chats'+sender.toString());
  }
  @override
  Widget build(BuildContext context) {

    TextEditingController messageEditingController=TextEditingController();
    addMessage() async {
      if (messageEditingController.text.isNotEmpty) {
        Map<String, dynamic> chatMessageMap = {
          "sendBy":await HelperFunctions.getUserNameFromSF(),
          "message": messageEditingController.text,
          'time': DateTime
              .now()
              .millisecondsSinceEpoch,
          "count":1
        };
DatabaseServices(uid:widget.uid).addMessage(widget.chatRoomId, chatMessageMap);


       messageEditingController.clear();
      }


    }

    return Scaffold(
backgroundColor: AppColors.darkNavyBlue,
      body:
      Container(
        child: Stack(
          children: [
            chatMessages(),
            Container(alignment: Alignment.bottomCenter,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                color: Color(0x54FFFFFF),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageEditingController,
                          // style: simpleTextStyle(),
                          decoration: InputDecoration(
                              hintText: "Message ...",
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red))
                          ),
                        )),
                    SizedBox(width: 16,),
                    GestureDetector(
                      onTap: () {
                        addMessage();
                      },
                      child: Icon(Icons.send,color: Colors.blueGrey,size: 20,),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
int counter=0;
class MessageTile extends StatefulWidget {
  final String message;
  final bool sendByMe;
  final String sentFrom;
  final String sentTo;

  MessageTile({required this.message, required this.sendByMe,required this.sentFrom,required this.sentTo});

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {


  @override
  Widget build(BuildContext context) {
        (){

          if(widget.sendByMe==true){
          print('sent by me');
          }
          else
            {
              setState(() {
                counter++;
              });
              print('counter: $counter');
            }

        }();

    return Column(


      children: [
        Container(
          padding: EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: widget.sendByMe ? 0 : 20,
              right: widget.sendByMe ? 20 : 0),
          alignment: widget.sendByMe ? Alignment.centerRight : Alignment.centerLeft,
          child:
          Container(
            margin: widget.sendByMe
                ? EdgeInsets.only(left: 30)
                : EdgeInsets.only(right: 30),
            padding: EdgeInsets.only(
                top: 17, bottom: 17, left: 20, right: 20),
            decoration: BoxDecoration(
                borderRadius: widget.sendByMe ? BorderRadius.only(
                    // topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23)
                ) :
                BorderRadius.only(
                    topLeft: Radius.circular(23),
                    // topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
                gradient: LinearGradient(
                  colors: widget.sendByMe ? [
                    AppColors.lightNavyBlue,
                    AppColors.lightNavyBlue,
                  ]
                      : [
                    AppColors.darkBlue,
                    AppColors.darkBlue,
                  ],
                )
            ),
            child: Text(widget.message,
                textAlign: TextAlign.start,
                style:TextDimensions.style17RajdhaniW400White),
          ),
        ),
    Container(
      // color: Colors.red,
      margin: widget.sendByMe
          ? EdgeInsets.only(left: 220)
          : EdgeInsets.only(right:220),
      padding: EdgeInsets.only(
          top: 17, bottom: 17, left: 20, right: 20),
      child:widget.sendByMe? Text(widget.sentFrom,style: TextDimensions.style12RajdhaniW600White,):
      Text(widget.sentTo,style: TextDimensions.style12RajdhaniW600White,),

    ),


      ],
    );
  }
}