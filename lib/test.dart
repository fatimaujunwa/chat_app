// import 'package:flutter/material.dart';
// import 'package:ichat/database_services.dart';
//
// class Test extends StatelessWidget {
//   const Test({Key? key, required this.uid}) : super(key: key);
// final String uid;
//   chatMessages()  {
//     return StreamBuilder(
//       stream:  DatabaseServices(uid: uid).getUserChats(widget.chatRoomId),
//       builder: (context, AsyncSnapshot<QuerySnapshot>stream){
//         return stream.hasData ?  ListView.builder(
//             itemCount: stream.data!.docs.length,
//             itemBuilder: (context, index){
//               return Text(
//                 stream.data!.docs[index]["message"],
//                 // sendByMe:  'Uju' == snapshot.data!.docs[index]["sendBy"],
//               );
//             }) : Container(
//           height: 100,
//           width: 100,
//           color: Colors.black,
//           child: Text('nope',style:TextStyle(color: Colors.white),),);
//       },
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: GestureDetector(
//           onTap: (){
//             DatabaseServices(uid: uid).test();
//           },
//           child: Container(
//             height: 100,
//             width: 100,
//             color: Colors.red,
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ichat/app_colors.dart';

import 'custom_textfield.dart';

class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController collectionDate=TextEditingController();
    return Scaffold(
      backgroundColor: AppColors.darkNavyBlue,
      body: Container(
        child: Center(child:
        CustomTextField(
          validator: (value ) {  },
          icon: Icon(Icons.lock),
          hintText: 'DD-MM-YY',
          height: 52.h,
          width: 350.w,
          color: AppColors.middleShadeNavyBlue,
          controller: collectionDate,
        ), ),
      ),
    );
  }
}

