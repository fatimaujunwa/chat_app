
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
import 'custom_snack_bar.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);
void register(BuildContext context,TextEditingController email,TextEditingController password, TextEditingController lastname,TextEditingController groupName,TextEditingController firstname,)async{
  String emailController=email.text.trim();
  String passwordController=password.text.trim();
  String firstNameController=firstname.text.trim();
  String groupNameController=groupName.text.trim();
  String lastNameController=lastname.text.trim();
  if (emailController.isEmpty && passwordController.isEmpty && firstNameController.isEmpty && lastNameController.isEmpty) {
    showCustomSnackBar('Please type in your details', "user details");
  }
  else{
    if (firstNameController.isEmpty) {
      showCustomSnackBar('firstname field is required', 'Sign in message');
    }
    else if (lastNameController.isEmpty) {
      showCustomSnackBar('lastname field is required', 'Sign in message');
    }
    else if (emailController.isEmpty) {
      showCustomSnackBar('email field is required', 'Sign in message');
    }
    else if (passwordController.isEmpty) {
      showCustomSnackBar('password field is required', 'Sign in message');
    }

    else{
      if (password.text.length < 8) {
        showCustomSnackBar(
            'password length is short please input a longer password',
            'Sign in message');
      }
      else{
        AuthServices().registerUserWithEmailAndPassword(emailController, passwordController, firstNameController,groupNameController,lastNameController)..then((value) {
          if(value==true){
            HelperFunctions.saveUserLoggedInStatus(value);
            HelperFunctions.saveUserEmailSF(emailController);
            HelperFunctions.saveUserNameSF(firstNameController);
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return SignInScreen();
            }));
          }


        });
      }



    }





  }







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
           icon: Icon(Icons.person,color:AppColors.whiteColor),
           hintText: 'John',
           height: 52.h,
           width: 350.w,
           prefixIcon: true,
           color: AppColors.middleShadeNavyBlue,
           controller:  firstName, validator: (value ) {  },
         ),

         SizedBox(height: 20.h,),
         Text('Last name',style: TextDimensions.style15RajdhaniW400White,),
         SizedBox(height: 6.h,),
         CustomTextField(
           icon: Icon(Icons.person,color: AppColors.whiteColor,),
           hintText: 'Doe',
           height: 52.h,
           width: 350.w,
           prefixIcon: true,
           controller:  lastName,
           color: AppColors.middleShadeNavyBlue, validator: (value ) {  },
         ),
         SizedBox(height: 20.h,),
         Text('Email',style: TextDimensions.style15RajdhaniW400White,),
         SizedBox(height: 6.h,),
         CustomTextField(
           icon: Icon(Icons.alternate_email,color:AppColors.whiteColor),
           hintText: 'johndoe01@gmail.com',
           height: 52.h,
           prefixIcon: true,
           width: 350.w,
           color: AppColors.middleShadeNavyBlue,
           controller:  email,

           validator: (value ) {  },
         ),
         SizedBox(height: 20.h,),
         // Text('Support Group',style: TextDimensions.style15RajdhaniW400White,),
         SizedBox(height: 6.h,),
         CustomDropDown(controller: supportGroupController),
         SizedBox(height: 20.h,),
         Text('Password',style: TextDimensions.style15RajdhaniW400White,),
         SizedBox(height: 6.h,),
         CustomTextField(
           icon: Icon(Icons.lock,color: AppColors.whiteColor,),
           hintText: '********',
           obsText: true,
           suffixIcon: true,
           prefixIcon: true,
           height: 52.h,
           width: 350.w,
           color: AppColors.middleShadeNavyBlue,
           controller:  password, validator: (value ) {  },
         ),
         SizedBox(height: 10.h,),
         Row(
           children: [
             Text('Have an account? ',style: TextDimensions.style12RajdhaniW600White,),
             GestureDetector(
               onTap: (){
                 Navigator.push(context, MaterialPageRoute(builder: (context){
                   return SignInScreen();
                 }));
               },
                 child: Text('Sign in',style: TextDimensions.style12RajdhaniW600BlueUnderline,)),


           ],
         ),
         SizedBox(height: 30.h,),
         GestureDetector(
           onTap: (){
             register(context, email, password, lastName, supportGroupController, firstName);
           },
           child: Container(height: 52.h,
             width: 350.w,
             color:AppColors.darkBlue,
             child: Center(child: Text('SIGN UP & ACCEPT',style: TextDimensions.style17RajdhaniW600White,)),
           ),
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