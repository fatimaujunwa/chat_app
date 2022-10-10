import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ichat/text_dimensions.dart';

import 'app_colors.dart';

class CustomDropDown extends StatefulWidget {
  const CustomDropDown({Key? key, required this.controller}) : super(key: key);
  final TextEditingController controller;

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String dropdownvalue = 'Select Support Group';
  var items = [
    'Select Support Group',
    'HIV/AIDS',
    'CANCER',
    'DRUGS',
    'ALCOHOL',
    'PTSD',
    'MENTAL HEALTH'
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Support Group',style: TextDimensions.style15RajdhaniW400White,),
          SizedBox(height: 8.h,),
          Container(
              padding: EdgeInsets.only(left: 10.w),
              height: 58.0.h,
              width: 350.w,
              decoration: BoxDecoration(
                // borderRadius: new BorderRadius.circular(12.r),
                color: AppColors.middleShadeNavyBlue,
              ),

              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
            dropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              color: AppColors.darkNavyBlue,
              
              border: Border.all(color: AppColors.lightNavyBlue,width: 1.5)
                  
            ),
                  hint: Text(
                    'Select Item',
                    style:TextDimensions.style15RajdhaniW400White,
                  ),
                  items: items
                      .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                        item,
                        style: TextDimensions.style15RajdhaniW400White
                    ),
                  ))
                      .toList(),
                  value: dropdownvalue,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                      widget.controller.text=dropdownvalue;
                    });
                  },
                  buttonHeight: 40,
                  buttonWidth: 140,
                  itemHeight: 40,
                ),
              )),
        ],
      ),
    );
  }
}