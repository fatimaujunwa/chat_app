
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ichat/app_colors.dart';
import 'package:ichat/custom_drop_down.dart';
import 'package:ichat/custom_textfield.dart';
import 'package:ichat/helper_functions.dart';
import 'package:ichat/sign_in_screen.dart';
import 'package:ichat/text_dimensions.dart';

import 'auth_services.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);
void register(TextEditingController email,TextEditingController password, TextEditingController fullName)async{
  String emailController=email.text.trim();
  String passwordController=password.text.trim();
  String fullNameController=fullName.text.trim();
  AuthServices().registerUserWithEmailAndPassword(emailController, passwordController, fullNameController)..then((value) {
    if(value==true){
      HelperFunctions.saveUserLoggedInStatus(value);
      HelperFunctions.saveUserEmailSF(emailController);
      HelperFunctions.saveUserNameSF(fullNameController);
    }
  });

}
  @override
  Widget build(BuildContext context) {
  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();
  TextEditingController firstName=TextEditingController();
  TextEditingController lastName=TextEditingController();
  TextEditingController supportGroupController=TextEditingController();
    return Scaffold(
      backgroundColor: AppColors.darkNavyBlue,
      body: Container(
        margin: EdgeInsets.only(left: 23.w,right: 23.w),
     child:
     Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         SizedBox(height: 40.h,),
         Text('SIGN UP',style: TextDimensions.style36RajdhaniW700White,),
SizedBox(height: 53.h,),
         Text('First name',style: TextDimensions.style15RajdhaniW400White,),
         SizedBox(height: 6.h,),
         CustomTextField(
           hintText: 'John',
           height: 52.h,
           width: 350.w,
           controller:  firstName,
         ),

         SizedBox(height: 20.h,),
         Text('Last name',style: TextDimensions.style15RajdhaniW400White,),
         SizedBox(height: 6.h,),
         CustomTextField(
           hintText: 'Doe',
           height: 52.h,
           width: 350.w,
           controller:  lastName,
         ),
         SizedBox(height: 20.h,),
         Text('Email',style: TextDimensions.style15RajdhaniW400White,),
         SizedBox(height: 6.h,),
         CustomTextField(
           hintText: 'johndoe01@gmail.com',
           height: 52.h,
           width: 350.w,
           controller:  email,
         ),
         SizedBox(height: 20.h,),
         // Text('Support Group',style: TextDimensions.style15RajdhaniW400White,),
         SizedBox(height: 6.h,),
         CustomDropDown(controller: supportGroupController),
         SizedBox(height: 20.h,),
         Text('Password',style: TextDimensions.style15RajdhaniW400White,),
         SizedBox(height: 6.h,),
         CustomTextField(
           hintText: '********',
           obsText: true,
           suffixIcon: true,
           height: 52.h,
           width: 350.w,
           controller:  password,
         ),
         SizedBox(height: 10.h,),
         Row(
           children: [
             Text('Have an account? ',style: TextDimensions.style12RajdhaniW600White,),
             Text('Sign in',style: TextDimensions.style12RajdhaniW600BlueUnderline,),


           ],
         ),
         SizedBox(height: 30.h,),
         Container(height: 52.h,
           width: 350.w,
           color:AppColors.darkBlue,
           child: Center(child: Text('SIGN UP & ACCEPT',style: TextDimensions.style17RajdhaniW600White,)),
         ),
         SizedBox(height: 15.h,),
         // Text('By tapping “Sign Up & Accept”, you acknowledge that you have read the Privacy Policy and agreed to the Terms of Service.',style: TextDimensions.style12RajdhaniW600White,)

       ],
     ),
      ),
    );
  }
}
//16/ENG02/057f
//ujunwafatima@gmail.com