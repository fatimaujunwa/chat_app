import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ichat/app_colors.dart';
import 'package:ichat/text_dimensions.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({Key? key,
    this.hintText = '',
    this.suffixIcon = false,
    this.prefixIcon=false,
    this.obsText = false,
    this.width=0.0,
    this.height=0.0,
    required this.controller,
 required this.color,
    required this.icon,




  }) : super(key: key,);
  final String hintText;
  final bool suffixIcon;
  final bool obsText;
  final double height;
  final double width;
  final bool prefixIcon;
  final Color color;
  final Widget icon;

  final TextEditingController controller;
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool visibility=false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      // padding: EdgeInsets.only(top: 40.h),
      // height:40.h ,
      // width: 330.w,
      child:   TextField(
        style: TextDimensions.style15RajdhaniW400White,
        controller: widget.controller,
        obscureText:visibility ? true : false,
        
        decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextDimensions.style15RajdhaniW400White,
            isDense: true,

            counterText: "",
            suffixIcon: widget.suffixIcon
                ?
            InkWell(
              onTap: (){

                setState(() {
                  visibility=!visibility;
                });
              },
              child: visibility?Icon(Icons.visibility_off,color: AppColors.whiteColor,size: 20,):
              Icon(Icons.visibility,color: AppColors.whiteColor,size: 20,),
            )
                : Text(''),
            filled: true,
            prefixIcon: widget.prefixIcon?widget.icon:Text(""),
            fillColor: widget.color,
            border: OutlineInputBorder(
                // borderRadius: new BorderRadius.circular(10.0),
                borderSide: BorderSide.none)),
        textAlign: TextAlign.start,
        maxLines: 1,
        maxLength: 20,
        // controller: _locationNameTextController,
      ),
    );
  }
}
