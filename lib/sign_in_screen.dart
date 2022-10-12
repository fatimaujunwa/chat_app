import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ichat/chat_screen.dart';
import 'package:ichat/database_services.dart';
import 'package:ichat/helper_functions.dart';
import 'package:ichat/search_screen.dart';
import 'package:ichat/text_dimensions.dart';

import 'app_colors.dart';
import 'auth_services.dart';
import 'custom_textfield.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);
  void login(BuildContext context,TextEditingController email,TextEditingController password, TextEditingController firstname,TextEditingController groupName,TextEditingController lastname)async{
    String emailController=email.text.trim();
    String passwordController=password.text.trim();
    String firstNameController=firstname.text.trim();
    String groupNameController=groupName.text.trim();
    String lastNameController=lastname.text.trim();
    AuthServices().loginUserWithEmailAndPassword(emailController,
        passwordController, firstNameController,groupNameController,lastNameController)..then((value) async {
          if(value==true){
QuerySnapshot querySnapshot= await  DatabaseServices(
    uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(emailController);
HelperFunctions.saveUserLoggedInStatus(value);
HelperFunctions.saveUserEmailSF(emailController);
HelperFunctions.saveUserNameSF(querySnapshot.docs[0]['firstname']);
print(querySnapshot.docs[0]['firstname']);
Navigator.push(context, MaterialPageRoute(builder: (context){
  return ChatScreen(uid: FirebaseAuth.instance.currentUser!.uid);
}));
          }
    }
    );

  }
  @override
  Widget build(BuildContext context) {
    TextEditingController email=TextEditingController();
    TextEditingController password=TextEditingController();
    TextEditingController firstname=TextEditingController();
    TextEditingController groupName=TextEditingController();
    TextEditingController lastName=TextEditingController();
    return Scaffold(
      backgroundColor: AppColors.darkNavyBlue,
      body: Container(
        margin: EdgeInsets.only(left: 23.w,right: 23.w),
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50.h,),
            Text('SIGN IN',style: TextDimensions.style36RajdhaniW700White,),
            SizedBox(height: 53.h,),

            SizedBox(height: 20.h,),
            Text('Email',style: TextDimensions.style15RajdhaniW400White,),
            SizedBox(height: 6.h,),
            CustomTextField(
              icon: Icon(Icons.person),
              hintText: 'johndoe01@gmail.com',
              height: 52.h,
              width: 350.w,
              prefixIcon: true,
              color: AppColors.middleShadeNavyBlue,
              controller:  email,
            ),
            SizedBox(height: 20.h,),
            Text('Password',style: TextDimensions.style15RajdhaniW400White,),
            SizedBox(height: 6.h,),
            CustomTextField(
              icon:Icon( Icons.lock),
              prefixIcon: true,
              hintText: '********',
              obsText: true,
              suffixIcon: true,
              height: 52.h,
              width: 350.w,
              color: AppColors.middleShadeNavyBlue,
              controller:  password,
            ),
            SizedBox(height: 10.h,),
            Row(
              children: [
                Text('Dont\'t have an account? ',style: TextDimensions.style12RajdhaniW600White,),
                Text('Sign up',style: TextDimensions.style12RajdhaniW600BlueUnderline,),


              ],
            ),
            SizedBox(height: 30.h,),
            GestureDetector(
              onTap: ()=>login(context, email, password, firstname, groupName, lastName),
              child: Container(height: 52.h,
                width: 350.w,
                color:AppColors.darkBlue,
                child: Center(child: Text('SIGN IN',style: TextDimensions.style17RajdhaniW600White,)),
              ),
            ),



          ],
        ),
      ),
    );
  }
}
